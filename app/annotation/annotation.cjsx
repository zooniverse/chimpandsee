React = require 'react'
classnames = require 'classnames'
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
    loaderStyle: {}

  componentWillMount: ->
    if @props.user?
      @setState user: true

  componentDidMount: ->
    @loader = React.findDOMNode @refs.loader
    @overlay = React.findDOMNode(@refs.imageZoom).childNodes[0] #skylight-dialog__overlay
    @isFirefox = typeof InstallTrigger isnt 'undefined'

    if @props.skipImages
      @setState currentStep: 1
    else
      @setLoaderStyle()

    window.addEventListener 'keydown', @onPressSpaceBar

  componentWillReceiveProps: (nextProps) ->
    if nextProps.video isnt @props.video
      @loadCount = 0
      @setState favorited: false

    if nextProps.user? then @setState user: true else @setState user: false

    if nextProps.previews isnt @props.previews
      @loadCount = 0

      unless @props.skipImages
        @setLoaderStyle()
        React.findDOMNode(@refs.previewImgs).classList.remove 'full-opacity'

    if nextProps.skipImages is true and nextProps.skipImages isnt @props.skipImages
      @setState currentStep: 1

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @onPressSpaceBar

  setLoaderStyle: =>
    console.log('calling setLoaderStyle')
    if @props.srcWidth is 720
      @setState loaderStyle: lineHeight: (@props.srcHeight / 4) * 3 + 20 + "px", height: (@props.srcHeight / 4) * 3 + 20 + "px"
    else if @props.srcWidth is 640
      @setState loaderStyle: lineHeight: (@props.srcHeight / 2) * 3 + 10 + "px", height: (@props.srcHeight / 2) * 3 + 10 + "px"
  
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
    dialog = React.findDOMNode(@refs.imageZoom).childNodes[1] #skylight-dialog
    dialog.classList.add 'fade-out'
    @overlay.classList.add 'fade-out'

    #Wait for fade out animation
    setTimeout ( =>
      dialog.classList.remove 'fade-out'
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

      unless @props.skipImages
        React.findDOMNode(@refs.previewImgs).classList.add 'full-opacity'

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
      video = React.findDOMNode @refs.video
      if video.paused
        video.play()
      else
        video.pause()

  resetVideo: ->
    video = React.findDOMNode @refs.video
    video.pause()
    video.currentTime = 0

  setCurrentAnswers: (currentAnswers) ->
    @setState currentAnswers: currentAnswers

  resetCurrentAnswers: ->
    @setState currentAnswers: {}

  createPreviewImages: ->
      if @props.previews?.length is 9
        @props.previews
      else
        previewsWithPlaceholders = @props.previews
        count = 9 - @props.previews?.length
        for i in [0...count] by 1
          previewsWithPlaceholders.push "./assets/placeholder-preview.png"

        previewsWithPlaceholders

  render: ->
    cursor = Cursor.build(@)

    overlayStyles =
      position: 'fixed'
      top: 0
      left: 0
      width: '100%'
      height: '100%'
      zIndex: 99
      backgroundColor: 'rgba(0,0,0,0.7)'
      animation: 'fadeIn .25s forwards'

    skylightDialogStyles =
      animation: 'fadeIn .25s forwards'
      backgroundColor: '#111111'
      boxSizing: 'border-box'
      borderRadius: '8px'
      boxShadow: 'none'
      height: 'inherit'
      left: '20%'
      margin: '0 -25% 0 0'
      padding: '10px'
      position: 'fixed'
      top: '40px'
      width: '60%'
      zIndex: 100

    favoriteClasses = classnames
      'favorite-btn': true
      'disabled': @state.user is false
      'favorited': @state.favorited is true
      'hide': true if window.innerWidth < 401 and cursor.refine('currentStep').value is steps.length - 1

    guideClasses = classnames
      'guide-btn': true
      'guide-open': @props.guideIsOpen is true
      'hide': true if window.innerWidth < 401 and cursor.refine('currentStep').value is steps.length - 1

    favoriteToolTip = if @state.user is false
      "Sign up or log in to favorite"

    previewImages = @createPreviewImages()

    previews =
      previewImages.map (preview, i) =>
        <figure key={i}>
          <img src={preview} onLoad={@onImageLoad.bind(@, null)} onClick={@zoomImage.bind(null, i, preview) if window.innerWidth > 600} />
        </figure>

    source = if @isFirefox then @props.video.webm else @props.video.mp4
    source = source.replace('http://www.chimpandsee.org/', 'https://www.chimpandsee.org/')  #MS Edge compatibility
    type = if @isFirefox then "video/webm" else "video/mp4"

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        <div ref="loader" className="loading-spinner" style={@state.loaderStyle}><i className="fa fa-spinner fa-spin fa-4x"></i></div>
        {if cursor.refine('currentStep').value is 0
          <div ref="previewImgs" className='preview-imgs'>
            {previews}
          </div>
        }
        {if window.innerWidth > 600
          <SkyLight ref="imageZoom" 
          showOverlay={true} 
          overlayStyles={overlayStyles}
          dialogStyles={skylightDialogStyles}
          closeButtonStyle={display: 'none'} 
          afterOpen={@modifyOverlay}
          >
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
