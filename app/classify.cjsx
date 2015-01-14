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
    subject: "http://placehold.it/300&text=loading"
    previews: ["http://placehold.it/300&text=loading"]
    location: "Congo Rainforest"
    classification: null
    guideIsOpen: false
    modalIsOpen: false
    tutorialType: null

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect
    wrapper = document.getElementById('wrapper')
    wrapper.classList.remove 'push-right'

  onSubjectSelect: (e, subject) ->
    previews = subject.location.previews
    previews.pop() #temporary for fitting the current 9 preview image design
    @setState({
      subject: subject.location.standard
      previews: previews
      classification: new Classification {subject}
    })

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
      <Annotation
        subject={@state.subject}
        previews={@state.previews}
        classification={@state.classification}
        toggleGuide={@toggleGuide}
        guideIsOpen={@state.guideIsOpen}
        tutorialType={@state.tutorialType}
        openModal={@openModal}
      />
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} tutorialType={@state.tutorialType} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
