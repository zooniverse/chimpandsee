React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Cursor = require('react-cursor').Cursor
SkyLight = require 'react-skylight'

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

  srcWidth: 0

  imageLoadCount: 0

  loader: null
  overlay: null
  dialog: null

  getInitialState: ->
    currentStep: 0
    subStep: 0
    notes: []
    currentAnswers: {}
    zoomImageSrc: null
    favorited: false
    user: false

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentDidMount: ->
    @loader = @refs.loader.getDOMNode()
    @overlay = @refs.imageZoom.getDOMNode().childNodes[0] #skylight-dialog__overlay
    @dialog = @refs.imageZoom.getDOMNode().childNodes[1] #skylight-dialog

  componentWillReceiveProps: (nextProps) ->
    if nextProps.video isnt @props.video
      @setState favorited: false

    if nextProps.user? then @setState user: true else @setState user: false

    if nextProps.previews isnt @props.previews
      @imageLoadCount = 0
      @showLoader()
      @refs.previewImgs?.getDOMNode().classList.remove 'full-opacity'

    if nextProps.skipImages is true
      @showLoader()
      @setState currentStep: 1

  zoomImage: (preview) ->
    @setState zoomImageSrc: preview
    @refs.imageZoom.show() if window.innerWidth > 600

  onClickGuide: ->
    #workaround for Firefox bug
    isFirefox = typeof InstallTrigger isnt 'undefined'
    scrollElement = if isFirefox then document.documentElement else document.body

    animatedScrollTo scrollElement, 0, 1000

    @props.toggleGuide()

  onClickFavorite: ->
    if @state.favorited is false
      @setState favorited: true
      @props.classification.favorite = true
    else
      @setState favorited: false
      @props.classification.favorite = false

  modifyOverlay: ->
    @overlay.addEventListener 'click', @closeZoom

  closeZoom: ->
    @dialog.classList.add 'fade-out'
    @overlay.classList.add 'fade-out'

    #Wait for fade out animation
    setTimeout ( =>
      @dialog.classList.remove 'fade-out'
      @overlay.classList.remove 'fade-out'

      @refs.imageZoom.hide()
      @setState zoomImageSrc: null
      @overlay.removeEventListener 'click'
    ), 250

  onImageLoad: (i, event) ->
    if @imageLoadCount < @props.previews.length
      @imageLoadCount += 1

    if @imageLoadCount is 9
      # @srcWidth = event.target.naturalWidth
      @hideLoader()
      @refs.previewImgs?.getDOMNode().classList.add 'full-opacity'

  showLoader: ->
    @loader.classList.remove 'hide'

  hideLoader: ->
    @loader.classList.add 'hide'

  onVideoLoad: ->
    @checkSrcWidth()
    unless @loader.classList.contains 'hide'
      @hideLoader()

  checkSrcWidth: ->
    image = new Image
    width = ""
    image.onload = ->
      # console.log image.width
      width = image.width
    image.src = @props.previews[0]
    console.log width, typeof width
    if width is "640"
      console.log '640'
      return "640px"
    else
      return "100%"

  render: ->
    cursor = Cursor.build(@)

    favoriteClasses = cx
      'favorite-btn': true
      'disabled': @state.user is false
      'favorited': @state.favorited is true

    guideClasses = cx
      'guide-btn': true
      'guide-open': @props.guideIsOpen is true

    favoriteToolTip = if @state.user is false
      "Sign up or log in to favorite"

    loaderStyle =
      height: @refs.previewImgs?.getDOMNode().clientHeight
      lineHeight: @refs.previewImgs?.getDOMNode().clientHeight + "px"

    previews =
      @props.previews.map (preview, i) =>
        <figure key={i}>
          <img src={preview} onLoad={@onImageLoad.bind(@, null)} onClick={@zoomImage.bind(null, preview) if window.innerWidth > 600} />
        </figure>

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        <div ref="loader" className="loading-spinner" style={loaderStyle}><i className="fa fa-spinner fa-spin fa-4x"></i></div>
        {if cursor.refine('currentStep').value is 0
          <div ref="previewImgs" className='preview-imgs'>
            {previews}
          </div>
        }
        {if window.innerWidth > 600
          <SkyLight ref="imageZoom" showOverlay={true} afterOpen={@modifyOverlay}>
            <img onClick={@closeZoom} src={@state.zoomImageSrc} alt="preview image" />
            <button className="close-zoom-btn" onClick={@closeZoom}><img src="./assets/cancel-icon.svg" alt="cancel icon" /></button>
          </SkyLight>
        }
        {if cursor.refine('currentStep').value >= 1 and cursor.refine('currentStep').value isnt steps.length - 1
          <div className="video-container" style={minHeight: 480 + "px" if cursor.refine('currentStep').value is 1}>
            <video ref="video" onload={@onVideoLoad() if cursor.refine('currentStep').value is 1} poster={@props.previews[0]} controls width={@checkSrcWidth()}>
              <source src={@props.video.webm} type="video/webm" />
              <source src={@props.video.mp4} type="video/mp4" />
              Your browser does not support the video format. Please upgrade your browser.
            </video>
          </div>
        }
        {if @state.currentStep is steps.length - 1
          <Summary notes={@state.notes} openTutorial={@props.openTutorial} location={@props.location} video={@props.video} zooniverseId={@props.zooniverseId} />
        }
        <button data-tooltip={favoriteToolTip} className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={cursor.refine('currentAnswers')}
        notes={cursor.refine('notes')}
        classification={@props.classification}
        onClickGuide={@onClickGuide}
        skipImages={@props.skipImages}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
