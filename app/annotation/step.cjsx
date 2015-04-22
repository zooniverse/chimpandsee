React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

steps = require '../lib/steps'
chimp = steps[2][0].animal.options[2]
animatedScrollTo = require 'animated-scrollto'

Step = React.createClass
  displayName: 'Step'
  mixins: [ImmutableOptimizations(['step', 'currentAnswers'])]

  getInitialState: ->
    values: []

  onButtonClick: ({currentTarget}) ->
    button = currentTarget
    human = steps[2][0].animal.options[9]
    notAChimp = @animalCheck(button.value, chimp)

    switch
      when button.value is steps[0][0].presence.options[0] and @props.step.value is 0
        @storeSelection(button.name, button.value)
        setTimeout (=>
          console?.log 'send to classification', @props.classification
          @props.classification.annotate @props.currentAnswers.value
          @sendClassification()
          @nextSubject()
        )
      when button.value is steps[0][0].presence.options[1]
        @moveToNextStep()
      when button.value is steps[1][0].annotation.options[0]
        @storeSelection(button.name, button.value)
        setTimeout ( =>
          console?.log 'send to classification', @props.classification
          @props.classification.annotate @props.currentAnswers.value
          @props.resetVideo()
          @sendClassification()
          @nextSubject()
        )
      when button.value is steps[1][0].annotation.options[1] then @moveToNextStep()
      when button.value is steps[1][0].annotation.options[2] then @finishNote()
      when button.value is chimp
        @storeSelection(button.name, button.value)
        @storeSelection('number', '1')
        @props.step.set 3
        @props.subStep.set 0
      when button.value is human
        @storeSelection(button.name, button.value)
        @storeSelection('number', '1')
        @storeSelection('behavior', ['no behavior'])
        setTimeout (=> @addNote() )
      when button.value is notAChimp[0]
        @storeSelection(button.name, button.value)
        @storeSelection('number', '1')
        @props.step.set 3
        @props.subStep.set 3
      when steps[3][0].age.options.indexOf(button.value) >= 0
        @storeSelection(button.name, button.value)
        @props.step.set 3
        @props.subStep.set 1
      when steps[3][1].sex.options.indexOf(button.value) >= 0
        @storeSelection(button.name, button.value)
        @props.step.set 3
        @props.subStep.set 2
      when button.value is steps[4][0].summary.options[0] then @nextSubject()
      when steps[3][3].number.options.indexOf(button.value) >= 0
        @storeSelection(button.name, button.value)
      else
        button.classList.toggle 'btn-active' #Directly managing class on el because of bug
        @storeMultipleSelections(button.name, button.value)

  animalCheck: (buttonValue, excludeThisAnimal) ->
    notThisAnimal = _.without steps[2][0].animal.options, excludeThisAnimal
    otherAnimal = notThisAnimal.map (animal) ->
      animal if animal is buttonValue
    otherAnimal = _.compact(otherAnimal)
    otherAnimal

  componentWillReceiveProps: (nextProps) ->
    window.scrollTo 0, 0 if window.innerWidth < 601 and nextProps.step.value < 2

  storeMultipleSelections: (name, value) ->
    index = @state.values.indexOf(value)

    if index >= 0
      currentValues = @state.values
      currentValues.splice index, 1
      @setState values: currentValues
      @storeSelection(name, @state.values)
    else
      currentValues = @state.values
      currentValues.push value
      @setState values: currentValues
      @storeSelection(name, @state.values)

  clearMultipleSelection: ->
    @setState values: []

  storeSelection: (name, value) ->
    obj = {}
    obj[name] = value
    @props.currentAnswers.merge obj

  moveToNextStep: ->
    @props.step.set Math.min @props.step.value + 1, steps.length

  goToAnimalStep: (event) ->
    @clearMultipleSelection()
    button = event.target

    @props.step.set button.value
    @props.subStep.set 0

  goToSubStep: (event) ->
    @clearMultipleSelection()
    button = event.target

    @props.step.set 3
    @props.subStep.set button.value

  addNote: ->
    @clearMultipleSelection()
    @props.notes.push [@props.currentAnswers.value]
    @props.currentAnswers.set {}
    @props.step.set 1
    @props.subStep.set 0

  cancelNote: ->
    @props.step.set 1
    @props.subStep.set 0
    @props.currentAnswers.set {}
    @clearMultipleSelection()

  finishNote: ->
    console?.log 'send to classification', @props.classification
    @props.classification.annotate @props.notes.value
    @sendClassification()
    @props.step.set steps.length - 1
    @props.subStep.set 0
    @props.disableSkip()

  nextSubject: ->
    @props.notes.set []
    @props.currentAnswers.set {}
    if @props.skipImages is true
      @props.step.set 1
    else
      @props.step.set 0
    @props.subStep.set 0
    @props.showLoader()
    @props.enableSkip()
    Subject.next()

  sendClassification: ->
    @props.classification.send()
    console?.log 'classification send'

  render: ->
    cancelClasses = cx
      'cancel': true
      'hide': @props.step.value <= 1 or @props.step.value is steps.length - 1

    addDisabled = @state.values.length is 0

    addAndCancelStyle = switch
      when @props.step.value is 2 and window.innerWidth <= 400 then "top": "-110px"
      when @props.step.value is 2 and window.innerWidth > 400 and window.innerWidth <=450 then "top": "-95px"
      when @props.step.value is 3 and window.innerWidth <= 400 then "top": "-130px"
      when @props.step.value is 3 and window.innerWidth > 400 and window.innerWidth <= 450 then "top": "-115px"
      when @props.subStep.value is 3 and window.innerWidth > 450 then "marginTop": "52.5px"

    addClasses = cx
      'disabled': addDisabled
      'done': true
      'hidden': @props.step.value is 2 or @props.subStep.value < 2
      'hide': @props.step.value < 2 or @props.step.value is steps.length - 1

    stepButtons =
      if @props.step.value > 2 and @props.step.value isnt steps.length - 1
        firstStepClasses = cx
          'step-button': true
          'step-active': @props.step.value is 2
          'step-complete': @props.step.value > 2

        if @props.currentAnswers.value.animal is _.values(@props.currentAnswers.value)[0] is chimp
          subSteps = steps[3].map (step, i) =>
            stepBtnDisabled = _.values(@props.currentAnswers.value).length < i + 2
            stepBtnClasses = cx
              'step-button': true
              'step-active': @props.subStep.value is i
              'step-complete': i - 1 < @props.subStep.value - 1
              'disabled': stepBtnDisabled

            if i isnt steps[3].length - 1
              <span key={i}>
                <button className={stepBtnClasses} value={i} onClick={@goToSubStep} disabled={stepBtnDisabled}>{i+2}</button>
                <img src="./assets/small-dot.svg" alt="" />
              </span>
        else
          stepBtnClasses = cx
            'step-button': true
            'step-active': @props.subStep.value is 3

          subSteps =
            <span>
              <button className={stepBtnClasses} value="3" onClick={@goToSubStep}>2</button>
              <img src="./assets/small-dot.svg" alt="" />
            </span>

        <div className="step-buttons">
          <small>Steps</small>
          <span>
            <button className={firstStepClasses} value="2" onClick={@goToAnimalStep}>1</button>
            <img src="./assets/small-dot.svg" alt="" />
          </span>
          {subSteps}
        </div>

    step = for name, step of steps[@props.step.value][@props.subStep.value]
      buttons = step.options.map (option, i) =>
        disabled =
          switch
            when @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2] then true
            when @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0] then true

        classes = cx
          'btn-active': option in _.values(@props.currentAnswers.value)
          'disabled finish-disabled': @props.notes.value.length is 0 and option is steps[1][0].annotation.options[2]
          'disabled nothing-disabled': @props.notes.value.length > 0 and option is steps[1][0].annotation.options[0]

        <button className={classes} key={i} id="#{name}-#{i}" name={name} value={option} onClick={@onButtonClick} disabled={disabled}>
          {option}
        </button>

      <div key={name} className={name}>
        {unless step.question is null
          <div className="step-top">
            <div className="step-question">
              <p className="question">{step.question}</p>
              <p className="tip">Not sure? Check out the <a className="guide-link" onClick={@props.onClickGuide}>Field Guide</a>!</p>
            </div>
            {stepButtons}
          </div>}
        <div className="step-bottom">
          <button className={cancelClasses} onClick={@cancelNote} style={addAndCancelStyle}>Cancel</button>
          <div className="buttons-container">
            {buttons}
          </div>
          <button className={addClasses} onClick={@addNote} disabled={addDisabled} style={addAndCancelStyle}>Done</button>
        </div>
      </div>

    <div className="step">
      {step}
    </div>

module.exports = Step