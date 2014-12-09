React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Subject = require 'zooniverse/models/subject'
Cursor = require('react-cursor').Cursor

AnimateMixin = require "react-animate"

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
    @animate "image-flip", {transform: 'rotateY(180deg)'}, {transform: 'rotateY(0deg)'}, 'in-out', 1000

  zoomImage: (i) ->
    if @state.zoomImage is false
      @animate "zoom-image", {transition: 'all .5s ease-in-out'}, {transform: 'scale3d(3,3,2)', marginTop: '95px'}, 'in-out', 1000
      @setState zoomImage: true
      @setState zoomImageIndex: i
    else
      @animate "zoom-image", {transition: 'all .5s ease-in-out'}, {transform: 'scale3d(1,1,1)', marginTop: '0'}, 'in-out', 1000
      @setState zoomImage: false
      @setState zoomImageIndex: null

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
        <img style={if i is @state.zoomImageIndex then @getAnimatedStyle('zoom-image') else @getAnimatedStyle("image-flip")} src={preview} onClick={@zoomImage.bind(null, i)} />
      </li>

    <div className="annotation">
      <div className="subject">
        <div className="guide-btn" onClick={@props.onClickGuide}><img src="./assets/guide-icon.svg" alt="field guide button" /></div>
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
