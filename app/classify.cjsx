React = require 'react/addons'
cx = React.addons.classSet

Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

Subject = require 'zooniverse/models/subject'
Favorite = require 'zooniverse/models/favorite'
Classification = require 'zooniverse/models/classification'

# Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
wrapper = document.getElementById('wrapper')
body = document.getElementsByTagName('body')['0']
previewLoadingImages = [
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading",
  "http://placehold.it/310x179/111111&text=loading"]


module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    video: null
    previews: null
    zooniverseId: null
    location: null
    classification: null
    guideIsOpen: false
    tutorialIsOpen: false
    tutorialType: null
    isLoading: false

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoSubjects
    Subject.next()

  componentDidMount: ->
    unless @props.user?
      # Wait for load
      setTimeout ( =>
        @openTutorial 'general'
      ), 1500

  componentWillReceiveProps: (nextProps) ->
    unless nextProps.user?.classification_count > 0
      # Wait for load
      setTimeout ( =>
        @openTutorial 'general'
      ), 1500

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect
    Subject.off 'no-more', @onNoSubjects

    wrapper.classList.remove 'push-right'
    body.classList.remove 'no-scroll'

  isLoading: ->
    @setState
      isLoading: true
    setTimeout (=>
      @setState isLoading: false
    ), 500

  onSubjectSelect: (e, subject) ->
    # if @state.isLoading is true
    #   @setState previews: previewLoadingImages

    # setTimeout ( =>
    previews = subject.location.previews
    randomInt = Math.round(Math.random() * (2 - 0)) + 0

    @setState
      video: subject.location.standard
      previews: previews[randomInt]
      zooniverseId: subject.zooniverse_id
      location: subject.group.name
      classification: new Classification {subject}

    @state.classification.annotate previewsSet: randomInt
    # ), 500

  onNoSubjects: ->
    @refs.statusMessage.getDOMNode().innerHTML = "No more subjects. Please try again."

  toggleGuide: (e) ->
    if @state.guideIsOpen is false
      @setState guideIsOpen: true
      wrapper.classList.add 'push-right'
      body.classList.add 'no-scroll'
    else
      @onClickClose()

  onClickClose: ->
    @setState guideIsOpen: false
    wrapper.classList.remove 'push-right'
    body.classList.remove 'no-scroll'

  openTutorial: (type) ->
    @setState
      tutorialIsOpen: true
      tutorialType: type

  closeTutorial: ->
    @setState tutorialIsOpen: false

  render: ->
    classifyClasses = cx
      'classify': true
      'content': true
      'open-guide': @state.guideIsOpen is true

    hiddenChimpClasses = cx
      'hide': @state.isLoading is true or @state.previews is null
      'hidden-chimp-container': true

    <div className={classifyClasses}>
      <Guide onClickClose={@onClickClose} guideIsOpen={@state.guideIsOpen} />
      {unless @state.location is null
        <div className="location-container">
          <p>
            <span className="bold">Site:</span> {@state.location}
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
          isLoading={@isLoading}
          loadingState={@state.isLoading} />
      else
        <div ref="statusMessage"></div>
      }
      <SlideTutorial tutorialIsOpen={@state.tutorialIsOpen} onClickCloseSlide={@closeTutorial} tutorialType={@state.tutorialType} />
      <div className={hiddenChimpClasses}><img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" /></div>
    </div>
