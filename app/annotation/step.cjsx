React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
Summary = require './summary'

steps = require '../lib/steps'

Step = React.createClass
  displayName: 'Step'
  mixins: [ImmutableOptimizations(['step', 'currentAnswers'])]

  onButtonClick: (event) ->
    button = event.target
    notAChimp = _.without steps[2][0].animal.options, steps[2][0].animal.options[0] #chimp
    otherAnimal = notAChimp.map (animal) ->
      animal if animal is button.value
    otherAnimal = _.compact(otherAnimal)

    switch
      when button.value is steps[0][0].presence.options[0] and @props.step.value is 0
        @newSubject()
        @props.animateImages()
      when button.value is steps[0][0].presence.options[1] then @moveToNextStep()
      when button.value is steps[1][0].annotation.options[0]
        @props.step.set 0
        @newSubject()
      when button.value is steps[1][0].annotation.options[1] then @moveToNextStep()
      when button.value is steps[1][0].annotation.options[2] then @finishNote()
      when button.value is steps[2][0].animal.options[0] #chimp
        @storeSelection(button.name, button.value)
        @moveToNextStep()
      when button.value is otherAnimal[0]
        @storeSelection(button.name, button.value)
        @props.step.set 3
        @props.subStep.set 1
      when button.value is steps[4][0].summary.options[0] then @nextSubject()
      else
        @storeSelection(button.name, button.value)

  newSubject: ->
    @props.notes.set []
    @props.currentAnswers.set {}
    Subject.next()

  storeSelection: (name, value) ->
    obj = {}
    obj[name] = value
    @props.currentAnswers.merge obj

  moveToNextStep: ->
    @props.step.set Math.min @props.step.value + 1, steps.length

  goToStep: (i) ->
    if i is 1 and @props.currentAnswers.value.animal isnt steps[2][0].animal.options[0]
      @props.subStep.set 1
      @props.step.set i+2
    else if i is 0 and @props.currentAnswers.value.animal isnt steps[2][0].animal.options[0]
      @props.subStep.set 0
      @props.step.set i+2
    else
      @props.subStep.set 0
      @props.step.set i+2

  addNote: ->
    @props.notes.push [@props.currentAnswers.value]
    @props.currentAnswers.set {}
    @props.step.set 1
    @props.subStep.set 0

  cancelNote: ->
    @props.step.set 1
    @props.subStep.set 0
    @props.currentAnswers.set {}

  finishNote: ->
    console?.log 'send to classification', @props.notes.value
    @props.classification.annotate @props.notes.value
    @props.classification.send()
    @props.step.set steps.length - 1
    @props.subStep.set 0

  nextSubject: ->
    @props.step.set 0
    @props.subStep.set 0
    @newSubject()

  render: ->
    cancelClasses = cx({
      'cancel': true
      'hide': @props.step.value <= 1 or @props.step.value is steps.length - 1
    })

    nextDisabled = _.values(@props.currentAnswers.value).length is 0
    nextClasses = cx({
      'disabled': nextDisabled
      'next': true
      'hide': @props.step.value <= 2 or @props.step.value >= steps.length - 2
    })

    addDisabled = switch
      when _.values(@props.currentAnswers.value).length < 4 and _.values(@props.currentAnswers.value)[0] is steps[2][0].animal.options[0]
        true
      when _.values(@props.currentAnswers.value).length < 2 then true

    addClasses = cx({
      'disabled': addDisabled
      'done': true
      'hidden': @props.step.value is 2
      'hide': @props.step.value < 2 or @props.step.value is steps.length - 1
    })

    stepButtons = steps.map (step, i) =>
      stepBtnDisabled = _.values(@props.currentAnswers.value).length is 0

      stepBtnClasses = cx({
        'step-button': true
        'step-active': @props.step.value is i+2
        'step-complete': @props.step.value is i+3
        'disabled': stepBtnDisabled
      })

      if i < steps.length - 3 and @props.step.value isnt steps.length - 1
        <span key={i}>
          <button className={stepBtnClasses} value={i+2} onClick={@goToStep.bind(null, i)} disabled={stepBtnDisabled}>{i+1}</button>
          <img src="./assets/small-dot.svg" alt="" />
        </span>

    step = for name, step of steps[@props.step.value][@props.subStep.value]
      buttons = step.options.map (option, i) =>
        disabled =
          if @props.subject.value is "http://placehold.it/300x150&text=loading"
            true
          else
            switch
              when @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2] then true
              when @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0] then true

        classes = cx({
          'btn-active': option in _.values(@props.currentAnswers.value)
          'finish-disabled': @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2]
          'nothing-disabled': @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0]
        })
        <button className={classes} key={i} id="#{name}-#{i}" name={name} value={option} onClick={@onButtonClick} disabled={disabled}>
          {option}
        </button>

      <div key={name} className={name}>
        {unless step.question is null
          <div className="step-top">
            <div className="step-question">
              {step.question}
            </div>
            <div className="step-buttons">
              {stepButtons}
            </div>
          </div>}
        <div className="step-bottom">
          {if @props.step.value is steps.length - 1
            <Summary notes={@props.notes.value} tutorialType={@props.tutorialType} openModal={@props.openModal} />}
          <div className="buttons-container">
            {buttons}
          </div>
        </div>
      </div>

    <div className="step">
      <button className={cancelClasses} onClick={@cancelNote}>Cancel</button>
      <button className={nextClasses} onClick={@moveToNextStep} disabled={nextDisabled}>Next</button>
      <button className={addClasses} onClick={@addNote} disabled={addDisabled}>Done</button>
      {step}
    </div>

module.exports = Step