React = require 'react/addons'
cx = React.addons.classSet

Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

Subject = require 'zooniverse/models/subject'
Favorite = require 'zooniverse/models/favorite'
Classification = require 'zooniverse/models/classification'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: null
    previews: null
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
    wrapper = document.getElementById('wrapper')
    wrapper.classList.remove 'push-right'

  onSubjectSelect: (e, subject) ->
    setTimeout ( =>
      previews = subject.location.previews
      previews.pop() #temporary for fitting the current 9 preview image design
      @setState({
        subject: subject.location.standard
        previews: previews
        classification: new Classification {subject}
      })
      console.log 'state set', @state
    ), 1000

  onNoSubjects: ->
    @refs.statusMessage.getDOMNode().innerHTML = "No more subjects. Please try again."

  toggleGuide: (e) ->
    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    wrapper = document.getElementById('wrapper')

    if @state.guideIsOpen is false
      @setState guideIsOpen: true
      wrapper.classList.add 'push-right'
    else
      @onClickClose()

  onClickClose: ->
    wrapper = document.getElementById('wrapper')

    @setState guideIsOpen: false
    wrapper.classList.remove 'push-right'

  openModal: (type) ->
    @setState({
      modalIsOpen: true
      tutorialType: type
    })

  closeModal: ->
    @setState modalIsOpen: false

  render: ->
    <div className="classify content">
      <button className="tutorial-btn" onClick={@openModal.bind(null, "general")}>Tutorial</button>

      <Guide onClickClose={@onClickClose} guideIsOpen={@state.guideIsOpen} />
      <div className="location-container">
        <p><span className="bold">Site:</span> {@state.location}</p>
      </div>
      {unless @state.previews is null and @state.subject is null
        <Annotation
          subject={@state.subject}
          previews={@state.previews}
          classification={@state.classification}
          toggleGuide={@toggleGuide}
          guideIsOpen={@state.guideIsOpen}
          tutorialType={@state.tutorialType}
          openModal={@openModal}
          user={@props.user} />
      else
        <div ref="statusMessage" className="loading-container">Loading...</div>}
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} tutorialType={@state.tutorialType} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
