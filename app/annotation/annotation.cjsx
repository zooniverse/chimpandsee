React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Cursor = require('react-cursor').Cursor

AnimateMixin = require "react-animate"
animatedScrollTo = require 'animated-scrollto'

Subject = require 'zooniverse/models/subject'

Step = require './step'
Summary = require './summary'
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
    animating: false

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentWillReceiveProps: (nextProps) ->
    if nextProps.subject isnt @props.subject
      @setState favorited: false
      # @animate "image-slide", {}, {animation: 'fadeIn 0.5s forwards'}, 'ease-in-out', 500
      setTimeout (=>
        @setState animating: false
      ), 100

    if nextProps.user? then @setState user: true else @setState user: false

  # animateImages: ->
  #   @animate "image-slide", {}, {animation: 'fadeOut 0.5s forwards', animation: 'slideOut 0.5s forwards'}, 'ease-in-out', 500

  zoomImage: (i) ->
    # image = @refs["img-#{i}"].getDOMNode()
    # console.log image.clientWidth * 1/3
    if @state.zoomImage is false
      @setState({
        zoomImage: true
        zoomImageIndex: i
      })
      setTimeout ( =>
        previews = document.getElementsByClassName('fade-out')

        for preview in previews
          preview.classList.add 'hide'
      ), 500
      @animate "image-zoom", {transform: 'scale3d(1,1,1)'}, {transform: 'scale3d(2,2,3)'}, 'linear', 500

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
    else
      @setState favorited: false
      @props.classification.favorite = false

  render: ->
    cursor = Cursor.build(@)

    previewClasses = cx({
      'hide': cursor.refine('currentStep').value > 0
      'preview-imgs': true
      'adjust-width': @state.zoomImage is true
    })

    videoClasses = cx({
      'hide': cursor.refine('currentStep').value is 0 or cursor.refine('currentStep').value is steps.length - 1
      'video': true
    })

    favoriteClasses = cx({
      'favorite-btn': true
      'disabled': @state.user is false
      'favorited': @state.favorited is true
    })

    guideClasses = cx({
      'guide-btn': true
      'guide-open': @props.guideIsOpen is true
    })

    previews = @props.previews.map (preview, i) =>
      figClasses = cx({
        'animating-in': true
        'zoom-image': @state.zoomImage is true and i is @state.zoomImageIndex
        'fade-out': @state.zoomImage is true and i isnt @state.zoomImageIndex
        'animating-out': @state.animating is true
      })

      <figure key={i} ref="preview" className={figClasses}>
        <img ref="img-#{i}" style={if @state.zoomImage is true and @state.zoomImageIndex is i then @getAnimatedStyle("image-zoom")} src={preview} onClick={@zoomImage.bind(null, i) if window.innerWidth > 600} />
      </figure>

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        <div className={previewClasses}>
          {previews}
        </div>
        <div className={videoClasses}>
          <video poster={@props.previews[0]} src={@props.subject} width="100%" type="video/mp4" controls>
            Your browser does not support the video format. Please upgrade your browser.
          </video>
        </div>
        {if @state.currentStep is steps.length - 1
          <Summary notes={@state.notes} tutorialType={@state.tutorialType} openModal={@props.openModal} location={@props.location} />}
        <button className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={cursor.refine('currentAnswers')}
        notes={cursor.refine('notes')}
        subject={@props.subject}
        previews={@props.previews}
        animating={cursor.refine('animating')}
        classification={@props.classification}
        openModal={@props.openModal}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
