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
    if nextProps.video isnt @props.video
      @setState favorited: false

      setTimeout (=>
        @setState animating: false
      ), 800

    if nextProps.user? then @setState user: true else @setState user: false

  zoomImage: (i) ->
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
        # 'animating-in': true
        'zoom-image': @state.zoomImage is true and i is @state.zoomImageIndex
        'fade-out': @state.zoomImage is true and i isnt @state.zoomImageIndex
        'animating-out': @state.animating is true
      })

      <figure key={i} ref="figure" className={figClasses}>
        <img ref="img-#{i}" style={if @state.zoomImage is true and @state.zoomImageIndex is i then @getAnimatedStyle("image-zoom")} src={preview} onClick={@zoomImage.bind(null, i) if window.innerWidth > 600} />
      </figure>

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        <div className={previewClasses}>
          {previews}
        </div>
        <div className={videoClasses}>
          <video poster={@props.previews[0]} width="100%" controls muted>
            <source src={@props.video.webm} type="video/webm" />
            <source src={@props.video.mp4} type="video/mp4" />
            Your browser does not support the video format. Please upgrade your browser.
          </video>
        </div>
        {if @state.currentStep is steps.length - 1
          <Summary notes={@state.notes} openModal={@props.openModal} location={@props.location} video={@props.video} zooniverseId={@props.zooniverseId} />}
        <button className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={cursor.refine('currentAnswers')}
        notes={cursor.refine('notes')}
        video={@props.video}
        previews={cursor.refine('previews')}
        animating={cursor.refine('animating')}
        classification={@props.classification}
        openModal={@props.openModal}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
