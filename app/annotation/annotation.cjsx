React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Subject = require 'zooniverse/models/subject'
Cursor = require('react-cursor').Cursor

AnimateMixin = require "react-animate"
animatedScrollTo = require 'animated-scrollto'

Step = require './step'
Notes = require './notes'

Annotation = React.createClass
  displayName: 'Annotation'
  mixins: [AnimateMixin]

  getInitialState: ->
    currentStep: 0
    subStep: 0
    notes: []
    currentAnswers: {}
    video: null
    preview: ["http://placehold.it/300x150&text=loading"]
    zoomImage: false
    zoomImageIndex: null

  componentWillMount: ->
    setTimeout ( =>
      @setState video: @props.subject
      @setState preview: @props.preview
    ), 2000

  animateImages: ->
    @animate "image-flip", {transform: 'rotateY(180deg)'}, {transform: 'rotateY(0deg)'}, 'ease-in-out', 500

  zoomImage: (i) ->
    if @state.zoomImage is false
      @animate "image-zoom", {transform: 'scale3d(1,1,1)', transitionDuration: '500ms'}, {transform: 'scale3d(3,3,2)'}, 'ease-in-out', 500
      @setState zoomImage: true
      @setState zoomImageIndex: i
    else
      @setState zoomImage: false
      @setState zoomImageIndex: null

  componentWillReceiveProps: ->
    if @props.guideIsOpen is true
      @refs.guideIcon.getDOMNode().src = "./assets/guide-icon.svg"

  onClickGuide: ->
    if @props.guideIsOpen is false
      @refs.guideIcon.getDOMNode().src = "./assets/cancel-icon.svg"
      animatedScrollTo document.body, 0, 1000
    else
      @refs.guideIcon.getDOMNode().src = "./assets/guide-icon.svg"

    @props.toggleGuide()

  render: ->
    cursor = Cursor.build(@)

    previewClasses = cx({
      'hide': cursor.refine('currentStep').value > 0
      'preview-imgs': true
    })

    videoClasses = cx({
      'hide': cursor.refine('currentStep').value is 0
      'video': true
    })

    previews = cursor.refine('preview').value.map (preview, i) =>
      liClasses = cx({
        'hide': @state.zoomImage is true and i isnt @state.zoomImageIndex
      })

      <li key={i} className={liClasses}>
        <img style={if @state.zoomImage is true then @getAnimatedStyle("image-zoom") else @getAnimatedStyle('image-flip')} src={preview} onClick={@zoomImage.bind(null, i)} />
      </li>

    <div className="annotation">
      <div className="subject">
        <div className="guide-btn" onClick={@onClickGuide}><img ref="guideIcon" src="./assets/guide-icon.svg" alt="field guide button" /></div>
        <div className={previewClasses}>
          {previews}
        </div>
        <div className={videoClasses}>
          <img src={cursor.refine('video').value} />
        </div>
        <div className="favorite-btn"><img src="./assets/fav-icon.svg" alt="favorite button" /></div>
      </div>
      <Step step={cursor.refine('currentStep')} subStep={cursor.refine('subStep')} currentAnswers={cursor.refine('currentAnswers')} notes={cursor.refine('notes')} subject={cursor.refine('video')} preview={cursor.refine('preview')} animateImages={@animateImages} />
      <Notes notes={cursor.refine('notes')} />
    </div>

module.exports = Annotation
