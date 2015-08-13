React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Cursor = require('react-cursor').Cursor
SkyLight = require 'react-skylight'

animatedScrollTo = require 'animated-scrollto'

Subject = require 'zooniverse/models/subject'
Favorite = require 'zooniverse/models/favorite'

Step = require './step'
Summary = require './summary'
Notes = require './notes'

steps = require '../lib/steps'

Annotation = React.createClass
  displayName: 'Annotation'

  loadCount: 0
  loader: null
  overlay: null
  dialog: null
  isFirefox: false

  getInitialState: ->
    currentStep: 0
    subStep: 0
    notes: []
    currentAnswers: {}
    zoomImageCurrent: null
    zoomImageSrc: null
    favorited: false
    user: false

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentDidMount: ->
    @loader = @refs.loader.getDOMNode()
    @overlay = @refs.imageZoom?.getDOMNode().childNodes[0] #skylight-dialog__overlay
    @dialog = @refs.imageZoom?.getDOMNode().childNodes[1] #skylight-dialog
    @isFirefox = typeof InstallTrigger isnt 'undefined'

    if @props.skipImages is true
      @setState currentStep: 1

    window.addEventListener 'keydown', @onPressSpaceBar

  componentWillReceiveProps: (nextProps) ->
    if nextProps.video isnt @props.video
      @loadCount = 0
      @setState favorited: false

    if nextProps.user? then @setState user: true else @setState user: false

    if nextProps.previews isnt @props.previews
      @loadCount = 0
      @refs.previewImgs?.getDOMNode().classList.remove 'full-opacity'

    if nextProps.skipImages is true and nextProps.skipImages isnt @props.skipImages
      @setState currentStep: 1

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @onPressSpaceBar

  zoomImage: (i, preview) ->
    @setState({zoomImageCurrent: i, zoomImageSrc: preview})
    @refs.imageZoom.show() if window.innerWidth > 600

  onClickGuide: ->
    #workaround for Firefox bug
    scrollElement = if @isFirefox then document.documentElement else document.body

    animatedScrollTo scrollElement, 0, 1000

    @props.toggleGuide()

  onClickFavorite: ->
    if @state.favorited is false
      @setState favorited: true
      @props.classification.favorite = true
    else
      @setState favorited: false
      @props.classification.favorite = false

    if @state.currentStep is 4 #Summary step
      @manuallyFavoriteSubject()

  manuallyFavoriteSubject: ->
    favorite = new Favorite subjects: [Subject.current]
    if @state.favorited is false
      favorite.send().then => @setState favorited: true
    else
      favorite.delete().then => @setState favorited: false

  modifyOverlay: ->
    @overlay.addEventListener 'click', @closeZoom
    window.addEventListener 'keydown', @onPressKeyInZoom

  closeZoom: ->
    @dialog.classList.add 'fade-out'
    @overlay.classList.add 'fade-out'

    #Wait for fade out animation
    setTimeout ( =>
      @dialog.classList.remove 'fade-out'
      @overlay.classList.remove 'fade-out'

      @refs.imageZoom.hide()
      @setState({zoomImageCurrent: null, zoomImageSrc: null})
      @overlay.removeEventListener 'click', @closeZoom
      window.removeEventListener 'keydown', @onPressKeyInZoom
    ), 250

  onPressKeyInZoom: (e) ->
    if e.keyCode is 37 or e.keyCode is 39
      e.preventDefault()

      i = @state.zoomImageCurrent
      if e.keyCode is 37
        i -= 1
        if i < 0
          i = @props.previews.length - 1
      else
        i = (i + 1) % @props.previews.length

      @zoomImage(i, @props.previews[i])

  onImageLoad: (i, event) ->
    if @loadCount < @props.previews.length
      @loadCount += 1

    if @loadCount is 9
      @hideLoader()
      @refs.previewImgs?.getDOMNode().classList.add 'full-opacity'

  onVideoLoad: ->
    @loadCount = 1

    if @loadCount is 1
      #works for now
      setTimeout ( => @hideLoader()), 750

  showLoader: ->
    @loader.classList.remove 'hide'

  hideLoader: ->
    @loader.classList.add 'hide'

  onPressSpaceBar: (e) ->
    if e.keyCode is 32
      e.preventDefault()

      if @refs.video.getDOMNode().paused
        @refs.video.getDOMNode().play()
      else
        @refs.video.getDOMNode().pause()

  resetVideo: ->
    @refs.video.getDOMNode().pause()
    @refs.video.getDOMNode().currentTime = 0

  setCurrentAnswers: (currentAnswers) ->
    @setState currentAnswers: currentAnswers

  resetCurrentAnswers: ->
    @setState currentAnswers: {}

  render: ->
    cursor = Cursor.build(@)

    favoriteClasses = cx
      'favorite-btn': true
      'disabled': @state.user is false
      'favorited': @state.favorited is true
      'hide': true if window.innerWidth < 401 and cursor.refine('currentStep').value is steps.length - 1

    guideClasses = cx
      'guide-btn': true
      'guide-open': @props.guideIsOpen is true
      'hide': true if window.innerWidth < 401 and cursor.refine('currentStep').value is steps.length - 1

    favoriteToolTip = if @state.user is false
      "Sign up or log in to favorite"

    loaderStyle =
      height: @refs.previewImgs?.getDOMNode().clientHeight
      lineHeight: @refs.previewImgs?.getDOMNode().clientHeight + "px"

    previews =
      @props.previews?.map (preview, i) =>
        <figure key={i}>
          <img src={preview} onLoad={@onImageLoad.bind(@, null)} onClick={@zoomImage.bind(null, i, preview) if window.innerWidth > 600} />
        </figure>

    source = if @isFirefox then @props.video.webm else @props.video.mp4
    type = if @isFirefox then "video/webm" else "video/mp4"

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
          <div className="video-container" style={minHeight: 480 + "px" if cursor.refine('currentStep').value is 1 and window.innerWidth > 768}>
            <video
              ref="video"
              onload={@onVideoLoad() if cursor.refine('currentStep').value is 1}
              poster={@props.previews[0]}
              controls
              width={@props.srcWidth}
              src={source}
              type={type}
            >
              Your browser does not support the video format. Please upgrade your browser.
            </video>
          </div>
        }
        {if @state.currentStep is steps.length - 1
          <Summary notes={@state.notes} openTutorial={@props.openTutorial} location={@props.location} video={@props.video} />
        }
        <button data-tooltip={favoriteToolTip} className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
      </div>
      <Step
        step={cursor.refine('currentStep')}
        subStep={cursor.refine('subStep')}
        currentAnswers={@state.currentAnswers}
        notes={cursor.refine('notes')}
        classification={@props.classification}
        onClickGuide={@onClickGuide}
        skipImages={@props.skipImages}
        showLoader={@showLoader}
        enableSkip={@props.enableSkip}
        disableSkip={@props.disableSkip}
        resetVideo={@resetVideo}
        setCurrentAnswers={@setCurrentAnswers}
        resetCurrentAnswers={@resetCurrentAnswers}
      />
      <Notes notes={cursor.refine('notes')} step={cursor.refine('currentStep')} />
    </div>

module.exports = Annotation
