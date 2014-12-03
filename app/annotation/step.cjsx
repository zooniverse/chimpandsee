React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Subject = require 'zooniverse/models/subject'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

steps = require '../lib/steps'

Step = React.createClass
  displayName: 'Step'
  mixins: [ImmutableOptimizations(['step', 'currentAnswers'])]

  onButtonClick: (event) ->
    button = event.target
    notAChimp = _.without steps[2][0].animal.options, steps[2][0].animal.options[0] #chimp
    console.log steps[1][0].annotation.options[0], button.value
    notAChimp.map (animalOption) =>
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
        when button.value is animalOption
          @storeSelection(button.name, button.value)
          @props.step.set 3
          @props.subStep.set 1
        else
          @storeSelection(button.name, button.value)

  newSubject: ->
    @props.notes.set []
    @props.currentAnswers.set {}
    Subject.next()
    @props.subject.set Subject.current.location.standard

  storeSelection: (name, value) ->
    obj = {}
    obj[name] = value
    @props.currentAnswers.merge obj

  moveToNextStep: ->
    @props.step.set Math.min @props.step.value + 1, steps.length

  moveToPrevStep: ->
    @props.step.set @props.step.value - 1

  goToStep: (i) ->
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
    console.log 'send to classification'
    @props.step.set 0
    @props.subStep.set 0
    @props.notes.set []
    Subject.next()
    @props.subject.set Subject.current.location.standard

  render: ->
    cancelClasses = cx({
      'cancel': true
      'hidden': if @props.step.value <= 1 then true else false
    })

    nextClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length is 0 then true else false
      'next': true
      'hide': if @props.step.value <= 2 or @props.step.value is steps.length - 1 then true else false
    })
    nextDisabled = if Object.keys(@props.currentAnswers.value).length is 0 then true else false

    addClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length < 4 then true else false
      'add': true
      'hidden': unless @props.step.value is steps.length - 1 then true else false
    })

    stepButtons = steps.map (step, i) =>
      stepBtnClasses = cx({
        'step-button': true
        'step-active': if @props.step.value is i+2 then true else false
        'step-complete': if @props.step.value is i+3 then true else false
      })

      if i < steps.length - 2
        <span key={i}>
          <button className={stepBtnClasses} value={i+2} onClick={@goToStep.bind(null, i)}>{i+1}</button>
          <img src="./assets/small-dot.svg" alt="" />
        </span>

    step = for name, step of steps[@props.step.value][@props.subStep.value]
      buttons = step.options.map (option, i) =>
        disabled = switch
          when @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2] then true
          when @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0] then true

        classes = cx({
          'btn-active': if option in _.values(@props.currentAnswers.value) then true else false
          'finish-disabled': if @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2] then true else false
          'nothing-disabled': if @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0] then true else false
        })
        <button className={classes} key={i} id="#{name}-#{i}" name={name} value={option} onClick={@onButtonClick} disabled={disabled}>
          {option}
        </button>
      stepTopClasses = cx({
        'step-top': true
        'hide': if step.question is null then true else false
      })
      <div key={name} className={name}>
        <div className={stepTopClasses}>
          <div className="step-question">
            {step.question}
          </div>
          <div className="step-buttons">
            {stepButtons}
          </div>
        </div>
        <div className="step-bottom">
          <div className="buttons-container">
            {buttons}
          </div>
        </div>
      </div>

    <div className="step">
      <button className={cancelClasses} onClick={@cancelNote}>Cancel</button>
      <button className={nextClasses} onClick={@moveToNextStep} disabled={nextDisabled}>Next</button>
      <button className={addClasses} onClick={@addNote}>Done</button>
      {step}
    </div>

module.exports = Step