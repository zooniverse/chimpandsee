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

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    video: null
    previews: null
    zooniverseId: null
    location: "Congo Rainforest"
    classification: null
    guideIsOpen: false
    modalIsOpen: false
    tutorialType: null

  componentDidMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoSubjects
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect
    Subject.off 'no-more', @onNoSubjects

    wrapper.classList.remove 'push-right'
    body.classList.remove 'no-scroll'

  onSubjectSelect: (e, subject) ->
    setTimeout ( =>
      previews = subject.location.previews
      randomInt = Math.round(Math.random() * (2 - 0)) + 0
      @setState({
        video: subject.location.standard
        previews: previews[randomInt]
        zooniverseId: subject.zooniverse_id
        classification: new Classification {subject}
      })
      @state.classification.annotate previewsSet: randomInt
    ), 1000

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

  openModal: (type) ->
    @setState({
      modalIsOpen: true
      tutorialType: type
    })

  closeModal: ->
    @setState modalIsOpen: false

  render: ->
    classifyClasses = cx({
      'classify': true
      'content': true
      'open-guide': @state.guideIsOpen is true
    })
    <div className={classifyClasses}>
      <button className="tutorial-btn" onClick={@openModal.bind(null, "general")}>Tutorial</button>

      <Guide onClickClose={@onClickClose} guideIsOpen={@state.guideIsOpen} />
      <div className="location-container">
        <p><span className="bold">Site:</span> {@state.location}</p>
      </div>
      {unless @state.previews is null and @state.video is null
        <Annotation
          video={@state.video}
          previews={@state.previews}
          classification={@state.classification}
          toggleGuide={@toggleGuide}
          guideIsOpen={@state.guideIsOpen}
          tutorialType={@state.tutorialType}
          openModal={@openModal}
          user={@props.user}
          location={@state.location}
          zooniverseId={@state.zooniverseId} />
      else
        <div ref="statusMessage" className="loading-spinner"><i className="fa fa-spinner fa-spin fa-2x"></i></div>}
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} tutorialType={@state.tutorialType} />
      <div className="hidden-chimp-container"><img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" /></div>
    </div>
