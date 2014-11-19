React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Subject = require 'zooniverse/models/subject'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

stepOne =
  presence:
    question: ''
    options: [
      {choice: 'I see something'}
      {choice: 'Nothing here'}
    ]

stepTwo =
  animal:
    question: 'Which animal do you see?'
    options: [
      {choice: 'chimpanzee'}
      {choice: 'gorilla'}
      {choice: 'bird'}
      {choice: 'rodent'}
      {choice: 'elephant'}
    ]

stepThree =
  number:
    question: "How many animals?"
    options: [
      {choice: '1'}
      {choice: '2'}
      {choice: '3'}
      {choice: '4'}
      {choice: '5'}
      {choice: '6+'}
    ]
  time:
    question: 'What time of day?'
    options: [
      {choice:'day'}
      {choice: 'night'}
    ]
  view:
    question: 'Which side of the animal(s) do you see?'
    options: [
      {choice: 'front'}
      {choice: 'side'}
      {choice: 'back'}
    ]

steps = [stepOne, stepTwo, stepThree]

Step = React.createClass
  displayName: 'Step'
  mixins: [ImmutableOptimizations(['step', 'currentAnswers'])]

  onButtonClick: (event) ->
    button = event.target
    switch
      when button.value is steps[0].presence.options[0].choice then @moveToNextStep()
      when button.value is steps[0].presence.options[1].choice
        @props.notes.set []
        @props.currentAnswers.set {}
        Subject.next()
        @props.subject.set Subject.current.location.standard
      else
        obj = {}
        obj[button.name] = button.value
        @props.currentAnswers.merge obj

  moveToNextStep: ->
    @props.step.set Math.min @props.step.value + 1, steps.length

  moveToPrevStep: ->
    @props.step.set @props.step.value - 1

  addNote: ->
    document.getElementsByClassName('finish').disabled = false
    @props.notes.push [@props.currentAnswers.value]
    @props.currentAnswers.set {}
    @props.step.set 1

  finishNote: ->
    console.log 'send to classification'
    @props.step.set 0
    @props.notes.set []
    Subject.next()
    @props.subject.set Subject.current.location.standard

  render: ->
    step = for name, step of steps[@props.step.value]
      buttons = step.options.map (option, i) =>
        classes = cx({
          'btn-active': if option.choice in _.values(@props.currentAnswers.value) then true else false
        })
        <button className={classes} key={i} name={name} value={option.choice} onClick={@onButtonClick}>{option.choice}</button>
      <div key={name}>{step.question}<br />{buttons}</div>

    nextClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length is 0 then true else false
      'next': true
    })
    nextDisabled = if Object.keys(@props.currentAnswers.value).length is 0 then true else false

    addClasses = cx({
      'disabled': if Object.keys(@props.currentAnswers.value).length < 4 then true else false
      'add': true
    })
    addDisabled = if Object.keys(@props.currentAnswers.value).length < 4 then true else false

    finishClasses = cx({
      'disabled': if @props.notes.value.length is 0 then true else false
      'finish': true
    })
    finishDisabled = if @props.notes.value.length is 0 then true else false

    workflowButtons = switch
      when @props.step.value >= 1 and @props.step.value < (steps.length - 1)
        <div>
          <button className="prev" onClick={@moveToPrevStep}>Go Back</button>
          <button className={nextClasses} onClick={@moveToNextStep} disabled={nextDisabled}>Next</button>
        </div>
      when @props.step.value is (steps.length - 1)
        <div>
          <button className="prev" onClick={@moveToPrevStep}>Go Back</button>
          <button className={addClasses} onClick={@addNote} disabled={addDisabled}>Add Note</button>
        </div>

    <div>
      <div className="step">
        {step}
      </div>
      <div className="workflowButtons">
        {workflowButtons}
        <button className={finishClasses} onClick={@finishNote} disabled={finishDisabled}>Finish</button>
      </div>
    </div>

module.exports = Step