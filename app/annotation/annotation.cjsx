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
    notes: []
    currentAnswers: {}
    video: null
    preview: ["http://placehold.it/300x150&text=loading"]

  componentWillMount: ->
    setTimeout ( =>
      @setState video: @props.subject
      @setState preview: @props.preview
    ), 2000

  animateImages: ->
    @animate "image-flip", {transform: 'rotateY(180deg)'}, {transform: 'rotateY(0deg)'}, 'in-out', 1000

  render: ->
    cursor = Cursor.build(@)

    previewClasses = cx({
      'hide': if cursor.refine('currentStep').value > 0 then true else false
      'preview-imgs': true
    })

    videoClasses = cx({
      'hide': if cursor.refine('currentStep').value is 0 then true else false
      'video': true
    })

    previews = cursor.refine('preview').value.map (preview, i) =>
      <li key={i}><img style={@getAnimatedStyle("image-flip")} src={preview} /></li>

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
      <Step step={cursor.refine('currentStep')} currentAnswers={cursor.refine('currentAnswers')} notes={cursor.refine('notes')} subject={cursor.refine('video')} preview={cursor.refine('preview')} animateImages={@animateImages} />
      <Notes notes={cursor.refine('notes')} />
    </div>

module.exports = Annotation
