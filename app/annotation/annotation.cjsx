React = require 'react/addons'
cx = React.addons.classSet
_ = require 'underscore'
Subject = require 'zooniverse/models/subject'
Cursor = require('react-cursor').Cursor

Step = require './step'
Notes = require './notes'

Annotation = React.createClass
  displayName: 'Annotation'

  getInitialState: ->
    currentStep: 0
    notes: []
    currentAnswers: {}
    video: null
    preview: []

  componentWillMount: ->
    console.log @props.subject

    setTimeout ( =>
      @setState video: @props.subject
      @setState preview: @props.preview
    ), 2000

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

    previews = cursor.refine('preview').value.map (preview, i) ->
      <li key={i}><img src={preview} /></li>

    <div className="annotation">
      <div className="subject">
        <div className={previewClasses}>
          <div>
            {previews}
          </div>
        </div>
        <div className={videoClasses}>
          <img src={cursor.refine('video').value} />
        </div>
      </div>
      <div className="ui-buttons">
        <img className="guide" src="./assets/guide.svg" alt="field guide button" />
        <img className="favorite" src="./assets/favorite.svg" alt="favorite button" />
      </div>
      <Step step={cursor.refine('currentStep')} currentAnswers={cursor.refine('currentAnswers')} notes={cursor.refine('notes')} subject={cursor.refine('video')} />
      <Notes notes={cursor.refine('notes')} />
    </div>

module.exports = Annotation
