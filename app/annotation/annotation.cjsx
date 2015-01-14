React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Cursor = require('react-cursor').Cursor

AnimateMixin = require "react-animate"
animatedScrollTo = require 'animated-scrollto'

Subject = require 'zooniverse/models/subject'

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
    previews: ["http://placehold.it/300x150&text=loading"]
    zoomImage: false
    zoomImageIndex: null
    favorited: false

  componentWillMount: ->
    setTimeout ( =>
      @setState({
        video: @props.subject
        previews: @props.previews
      })
    ), 2000

  componentWillReceiveProps: (nextProps) ->
    if nextProps.guideIsOpen is false
      @refs.guideIcon.getDOMNode().src = "./assets/guide-icon.svg"
    else
      @refs.guideIcon.getDOMNode().src = "./assets/cancel-icon.svg"

    if nextProps.subject isnt @props.subject
      @setState favorited: false
      @refs.favoriteIcon.getDOMNode().src = "./assets/fav-icon.svg"

  animateImages: ->
    @animate "image-flip", {transform: 'rotateY(180deg)'}, {transform: 'rotateY(0deg)'}, 'ease-in-out', 500

  zoomImage: (i) ->
    if @state.zoomImage is false
      @animate "image-zoom", {transform: 'scale3d(1,1,1)', transitionDuration: '500ms', marginTop: '0'}, {transform: 'scale3d(2,2,2)', marginTop: '95px'}, 'ease-in-out', 500
      @setState zoomImage: true
      @setState zoomImageIndex: i
    else
      @setState zoomImage: false
      @setState zoomImageIndex: null

  onClickGuide: ->
    animatedScrollTo document.body, 0, 1000

    @props.toggleGuide()

  onClickFavorite: ->
    if @state.favorited is false
      @setState favorited: true
      @props.classification.favorite = true
      @refs.favoriteIcon.getDOMNode().src = "./assets/fav-icon-filled.svg"
    else
      @setState favorited: false
      @props.classification.favorite = false
      @refs.favoriteIcon.getDOMNode().src = "./assets/fav-icon.svg"

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

    previews = cursor.refine('previews').value.map (preview, i) =>
      figClasses = cx({
        'hide': @state.zoomImage is true and i isnt @state.zoomImageIndex
      })

      <figure key={i} className={figClasses} style={@getAnimatedStyle('image-flip')}>
        <img style={if @state.zoomImage is true then @getAnimatedStyle("image-zoom")} src={preview} onClick={@zoomImage.bind(null, i)} />
      </figure>

    <div className="annotation">
      <div className="subject">
        <div className="guide-btn" onClick={@onClickGuide}><img ref="guideIcon" src="./assets/guide-icon.svg" alt="field guide button" /></div>
        <div className={previewClasses}>
          {previews}
        </div>
        <div className={videoClasses}>
          <video poster={cursor.refine('previews').value[0]} src={cursor.refine('video').value} width="100%" type="video/mp4" controls>
            Your browser does not support the video format. Please upgrade your browser.
          </video>
        </div>
        <div className="favorite-btn" onClick={@onClickFavorite}><img ref="favoriteIcon" src="./assets/fav-icon.svg" alt="favorite button" /></div>
      </div>
      <Step step={cursor.refine('currentStep')} subStep={cursor.refine('subStep')} currentAnswers={cursor.refine('currentAnswers')} notes={cursor.refine('notes')} subject={cursor.refine('video')} previews={cursor.refine('previews')} animateImages={@animateImages} classification={@props.classification} />
      <Notes notes={cursor.refine('notes')} />
    </div>

module.exports = Annotation
