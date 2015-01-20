React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Cursor = require('react-cursor').Cursor

AnimateMixin = require "react-animate"
animatedScrollTo = require 'animated-scrollto'

Subject = require 'zooniverse/models/subject'

Step = require './step'
Notes = require './notes'

steps = require '../lib/steps'

Annotation = React.createClass
  displayName: 'Annotation'
  mixins: [AnimateMixin]

  getInitialState: ->
    currentStep: 0
    subStep: 0
    notes: []
    currentAnswers: {}
    zoomImage: false
    zoomImageIndex: null
    favorited: false
    user: false

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentWillReceiveProps: (nextProps) ->
    if nextProps.guideIsOpen is false
      @refs.guideIcon.getDOMNode().src = "./assets/guide-icon.svg"
    else
      @refs.guideIcon.getDOMNode().src = "./assets/cancel-icon.svg"

    if nextProps.subject isnt @props.subject
      @setState favorited: false
      @refs.favoriteIcon.getDOMNode().src = "./assets/fav-icon.svg"
      @animate "image-slide", {transform: 'translateX(0)', opacity: '0'}, {transform: 'translateX(0)', opacity: '1'}, 'ease-in-out', 500

    if nextProps.user? then @setState user: true else @setState user: false

  animateImages: ->
    @animate "image-slide", {transform: 'translateX(0)', opacity: '1'}, {transform: 'translateX(310px)', opacity: '0'}, 'ease-in-out', 500

  zoomImage: (i) ->
    if @state.zoomImage is false
      @setState({
        zoomImage: true
        zoomImageIndex: i
      })
      @animate "image-zoom", {transform: 'scale3d(1,1,1)'}, {transform: 'scale3d(2,2,2)'}, 'linear', 500
      setTimeout ( =>
        previews = document.getElementsByClassName('fade-out')

        for preview in previews
          preview.classList.add 'hide'
      ), 500
    else
      @setState({
        zoomImage: false
        zoomImageIndex: null
      })

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
      'hide': cursor.refine('currentStep').value is 0 or cursor.refine('currentStep').value is steps.length - 1
      'video': true
    })

    favoriteClasses = cx({
      'favorite-btn': true
      'hidden': @state.user is false
    })

    previews = @props.previews.map (preview, i) =>
      figClasses = cx({
        'zoom-image': @state.zoomImage is true and i is @state.zoomImageIndex
        'fade-out': @state.zoomImage is true and i isnt @state.zoomImageIndex
      })

      <figure key={i} ref="preview" className={figClasses} style={@getAnimatedStyle('image-slide')}>
        <img style={if @state.zoomImage is true and @state.zoomImageIndex is i then @getAnimatedStyle("image-zoom")} src={preview} onClick={@zoomImage.bind(null, i) if window.innerWidth > 600} width="auto" />
      </figure>

    <div className="annotation">
      <div className="subject">
        <div className="guide-btn" onClick={@onClickGuide}><img ref="guideIcon" src="./assets/guide-icon.svg" alt="field guide button" /></div>
        <div className={previewClasses}>
          {previews}
        </div>
        <div className={videoClasses}>
          <video poster={@props.previews[0]} src={@props.subject} width="100%" type="video/mp4" controls>
            Your browser does not support the video format. Please upgrade your browser.
          </video>
        </div>
        <div className={favoriteClasses} onClick={@onClickFavorite}>
          <img ref="favoriteIcon" src="./assets/fav-icon.svg" alt="favorite button" />
        </div>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={cursor.refine('currentAnswers')}
        notes={cursor.refine('notes')}
        subject={@props.subject}
        previews={@props.previews}
        animateImages={@animateImages}
        classification={@props.classification}
        tutorialType={@state.tutorialType}
        openModal={@props.openModal}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
