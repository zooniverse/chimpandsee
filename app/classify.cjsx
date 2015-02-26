React = require 'react/addons'
cx = React.addons.classSet

Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

Subject = require 'zooniverse/models/subject'
Favorite = require 'zooniverse/models/favorite'
Classification = require 'zooniverse/models/classification'
User = require 'zooniverse/models/user'

module?.exports = React.createClass
  displayName: 'Classify'

  wrapper: null
  body: null
  main: null

  getInitialState: ->
    video: null
    previews: null
    zooniverseId: null
    location: null
    classification: null
    guideIsOpen: false
    tutorialIsOpen: false
    tutorialType: null
    skipImages: false

  componentDidMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoSubjects
    Subject.next()

    if @props.user?
      if @props.user.preferences.chimp?.skip_first_step is "true"
        @setState skipImages: true
    else
      @openTutorial 'general'

    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    @wrapper = document.getElementById('wrapper')
    @body = document.getElementsByTagName('body')[0]
    @main = document.getElementsByClassName('main')[0]

  componentWillReceiveProps: (nextProps) ->
    unless nextProps.user?.classification_count > 0
      @openTutorial 'general'

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect
    Subject.off 'no-more', @onNoSubjects

    @removeClassesForGuide()

  onSubjectSelect: (e, subject) ->
    previews = subject.location.previews
    randomInt = Math.round(Math.random() * (2 - 0)) + 0
    @setState({
      video: subject.location.standard
      previews: previews[randomInt]
      zooniverseId: subject.zooniverse_id
      location: subject.group.name
      classification: new Classification {subject}
    }, => @onSubjectUpdate(randomInt))

  onSubjectUpdate: (integer) ->
    @state.classification.annotate previewsSet: integer

  onNoSubjects: ->
    @refs.statusMessage.getDOMNode().innerHTML = "No more subjects. Please try again."

  toggleGuide: (e) ->
    if @state.guideIsOpen is false
      @refs.guide.getDOMNode().scrollTop = 0
      @setState guideIsOpen: true
      @addClassesForGuide()
    else
      @onClickClose()

  onClickClose: ->
    @setState guideIsOpen: false
    @removeClassesForGuide()

  addClassesForGuide: ->
    @wrapper.classList.add 'push-right'
    @body.classList.add 'no-scroll'
    @main.classList.add 'scroll'

  removeClassesForGuide: ->
    @wrapper.classList.remove 'push-right'
    @body.classList.remove 'no-scroll'
    @main.classList.remove 'scroll'

  openTutorial: (type) ->
    @setState
      tutorialIsOpen: true
      tutorialType: type

  closeTutorial: ->
    @setState tutorialIsOpen: false

  onClickSkipCheckbox: (e) ->
    checkbox = e.target

    if checkbox.checked is true
      @setUserSkipPreference(true)
      @setState skipImages: true
    else
      @setUserSkipPreference(false)
      @setState skipImages: false

  setUserSkipPreference: (value) ->
    User.current?.setPreference 'skip_first_step', value

  render: ->
    classifyClasses = cx
      'classify': true
      'content': true
      'open-guide': @state.guideIsOpen is true

    hiddenChimpClasses = cx
      'hide': @state.previews is null
      'hidden-chimp-container': true

    <div className={classifyClasses}>
      <Guide ref="guide" onClickClose={@onClickClose} guideIsOpen={@state.guideIsOpen} />
      {unless @state.location is null
        <div className="location-container">
          <p>
            <span className="bold">Site:</span> {@state.location}
            <label className="skip-checkbox-label" htmlFor="skip-checkbox">
              <input ref="skipCheckbox" defaultChecked={@props.user?.preferences?.chimp?.skip_first_step is "true"} type="checkbox" id="skip-checkbox" onClick={@onClickSkipCheckbox}/> Skip images?
            </label>
            <button className="tutorial-btn" onClick={@openTutorial.bind(null, "general")}>Tutorial</button>
            <a href="https://www.zooniverse.org" target="_blank"><button className="faq-btn">FAQs</button></a>
          </p>
        </div>
      }
      {unless @state.previews is null and @state.video is null
        <Annotation
          video={@state.video}
          previews={@state.previews}
          classification={@state.classification}
          toggleGuide={@toggleGuide}
          guideIsOpen={@state.guideIsOpen}
          tutorialType={@state.tutorialType}
          openTutorial={@openTutorial}
          user={@props.user}
          location={@state.location}
          zooniverseId={@state.zooniverseId}
          skipImages={@state.skipImages} />
      else
        <div ref="statusMessage"></div>
      }
      <SlideTutorial tutorialIsOpen={@state.tutorialIsOpen} closeTutorial={@closeTutorial} tutorialType={@state.tutorialType} />
      <div className={hiddenChimpClasses}><img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" /></div>
    </div>
