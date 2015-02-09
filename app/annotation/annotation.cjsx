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

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentWillReceiveProps: (nextProps) ->
    if nextProps.video isnt @props.video
      @setState favorited: false

    if nextProps.user? then @setState user: true else @setState user: false

  componentDidMount: ->
    @props.isLoading()

  zoomImage: (i) ->
    if @state.zoomImage is false
      @setState
        zoomImage: true
        zoomImageIndex: i

      @animate "image-zoom", {transform: 'scale3d(1,1,1)'}, {transform: 'scale3d(2,2,3)'}, 'linear', 500, @fadeout()

    else
      @setState
        zoomImage: false
        zoomImageIndex: null

  fadeout: =>
    setTimeout ( =>
      previews = document.getElementsByClassName('fade-out')

      for preview in previews
        preview.classList.add 'hide'
    ), 500

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

    previewClasses = cx
      'preview-imgs': true
      'adjust-width': @state.zoomImage is true

    favoriteClasses = cx
      'favorite-btn': true
      'disabled': @state.user is false
      'favorited': @state.favorited is true

    guideClasses = cx
      'guide-btn': true
      'guide-open': @props.guideIsOpen is true

    previews = @props.previews.map (preview, i) =>
      figClasses = cx
        'zoom-image': @state.zoomImage is true and i is @state.zoomImageIndex
        'fade-out': @state.zoomImage is true and i isnt @state.zoomImageIndex

      <figure key={i} ref="figure" className={figClasses}>
        <img
          ref="img-#{i}"
          style={if @state.zoomImage is true and @state.zoomImageIndex is i then @getAnimatedStyle("image-zoom")}
          src={preview}
          onClick={@zoomImage.bind(null, i) if window.innerWidth > 600} />
      </figure>

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        {if @props.loadingState is true
          <div className="loading-spinner"><i className="fa fa-spinner fa-spin fa-4x"></i></div>
        }
        {if cursor.refine('currentStep').value is 0
          <div className={previewClasses}>
            {previews}
          </div>
        }
        {if cursor.refine('currentStep').value >= 1 and cursor.refine('currentStep').value isnt steps.length - 1
          <div className="video">
            <video ref="video" poster={@props.previews[0]} width="100%" controls muted>
              <source src={@props.video.webm} type="video/webm" />
              <source src={@props.video.mp4} type="video/mp4" />
              Your browser does not support the video format. Please upgrade your browser.
            </video>
          </div>
        }
        {if @state.currentStep is steps.length - 1
          <Summary notes={@state.notes} openTutorial={@props.openTutorial} location={@props.location} video={@props.video} zooniverseId={@props.zooniverseId} />
        }
        <button className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={cursor.refine('currentAnswers')}
        notes={cursor.refine('notes')}
        classification={@props.classification}
        isLoading={@props.isLoading}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
