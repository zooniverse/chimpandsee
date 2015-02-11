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
    @props.isLoading()

  componentWillReceiveProps: (nextProps) ->
    if nextProps.video isnt @props.video
      @setState favorited: false

    if nextProps.user? then @setState user: true else @setState user: false

  zoomImage: (preview) ->
    @setState zoomImageSrc: preview
    @refs.imageZoom.show() if window.innerWidth > 600

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

  modifyOverlay: ->
    overlay = @refs.imageZoom.getDOMNode().childNodes[0] #skylight-dialog__overlay
    classify = @getDOMNode().parentNode #classify
    footer = document.getElementById('footer')
    dialog = @refs.imageZoom.getDOMNode().childNodes[1] #skylight-dialog

    # modifying height since footer and topbar exist outside of React's virtual DOM
    overlay.style.height = footer.clientHeight + classify.clientHeight + 100 + "px"
    overlay.addEventListener 'click', @closeZoom

  closeZoom: ->
    overlay = @refs.imageZoom.getDOMNode().childNodes[0] #skylight-dialog__overlay
    dialog = @refs.imageZoom.getDOMNode().childNodes[1] #skylight-dialog
    dialog.classList.add 'fade-out'
    overlay.classList.add 'fade-out'

    #Wait for fade out animation
    setTimeout ( =>
      dialog.classList.remove 'fade-out'
      overlay.classList.remove 'fade-out'

      @refs.imageZoom.hide()
      @setState zoomImageSrc: null
      overlay.removeEventListener 'click'
    ), 500

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

    previews = @props.previews.map (preview, i) =>
      <figure key={i} ref="figure">
        <img
          src={preview}
          onClick={@zoomImage.bind(null, preview) if window.innerWidth > 600} />
      </figure>

    <div className="annotation">
      <div className="subject">
        <button className={guideClasses} onClick={@onClickGuide}>Field Guide</button>
        {if @props.loadingState is true
          <div className="loading-spinner"><i className="fa fa-spinner fa-spin fa-4x"></i></div>
        }
        {if cursor.refine('currentStep').value is 0
          <div className='preview-imgs'>
            {previews}
          </div>
        }
        {if window.innerWidth > 600
          <SkyLight ref="imageZoom" showOverlay={true} afterOpen={@modifyOverlay}>
            <img onClick={@closeZoom} src={@state.zoomImageSrc} alt="preview image" />
            <button className="close-zoom-btn" onClick={@closeZoom}>x</button>
          </SkyLight>
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
        <button data-tooltip={favoriteToolTip} className={favoriteClasses} onClick={@onClickFavorite} disabled={@state.user is false}>Favorite</button>
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
