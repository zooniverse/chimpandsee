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

    steps[1].animal.options.map (animalOption) =>
      switch
        when button.value is steps[0].presence.options[0]
          @props.notes.set []
          @props.currentAnswers.set {}
          Subject.next()
          @props.subject.set Subject.current.location.standard
          @props.animateImages()
        when button.value is steps[0].presence.options[1] then @moveToNextStep()
        when button.value is animalOption
          @storeSelection(button.name, button.value)
          @moveToNextStep()
        else
          @storeSelection(button.name, button.value)

  storeSelection: (name, value) ->
    obj = {}
    obj[name] = value
    @props.currentAnswers.merge obj

  moveToNextStep: ->
    @props.step.set Math.min @props.step.value + 1, steps.length

  moveToPrevStep: ->
    @props.step.set @props.step.value - 1

  addNote: ->
    @props.notes.push [@props.currentAnswers.value]
    @props.currentAnswers.set {}
    @props.step.set 1

  cancelNote: ->
    @props.step.set 0
    @props.currentAnswers.set {}

  finishNote: ->
    console.log 'send to classification'
    @props.step.set 0
    @props.notes.set []
    Subject.next()
    @props.subject.set Subject.current.location.standard

  render: ->
    stepTopClasses = cx({
      'step-top': true
      'hide': if @props.step.value is 0 then true else false
    })

    cancelClasses = cx({
      'cancel': true
      'hide': if @props.step.value is 0 then true else false
    })

    nextClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length is 0 then true else false
      'next': true
      'hide': if @props.step.value is 0 then true else false
    })
    nextDisabled = if Object.keys(@props.currentAnswers.value).length is 0 then true else false

    step = for name, step of steps[@props.step.value]
      buttons = step.options.map (option, i) =>
        classes = cx({
          'btn-active': if option in _.values(@props.currentAnswers.value) then true else false
        })
        <button className={classes} key={i} name={name} value={option} onClick={@onButtonClick}>{option}</button>
      <div key={name} className={name}>
        <div className={stepTopClasses}>
          {step.question}
        </div>
        <button className={cancelClasses} onClick={@cancelNote}>X</button>
        <button className={nextClasses} onClick={@moveToNextStep} disabled={nextDisabled}>&rarr;</button>
        <div className="step-bottom">
          {buttons}
        </div>
      </div>



    addClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length < 4 then true else false
      'add': true
    })
    addDisabled = if Object.keys(@props.currentAnswers.value).length < 4 then true else false

    finishDisabled = if @props.notes.value.length is 0 then true else false
    finishClasses = cx({
      'disabled': finishDisabled
      'finish': true
    })

    workflowButtons = switch
      when @props.step.value >= 1 and @props.step.value < (steps.length - 1)
        <div>
          <button className="prev" onClick={@moveToPrevStep}>Go Back</button>
        </div>
      when @props.step.value is (steps.length - 1)
        <div>
          <button className="prev" onClick={@moveToPrevStep}>Go Back</button>
          <button className={addClasses} onClick={@addNote} disabled={addDisabled}>Done</button>
        </div>

    finishButton =
      if @props.notes.value.length
        <button className={finishClasses} onClick={@finishNote} disabled={finishDisabled}>Next Subject</button>

    <div>
      <div className="step">
        {step}
      </div>
      <div className="workflowButtons">{workflowButtons}{finishButton}</div>
    </div>

module.exports = Step