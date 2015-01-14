React = require 'react/addons'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

steps = require '../lib/steps'

Notes = React.createClass
  displayName: 'Notes'

  mixins: [ImmutableOptimizations(['notes'])]

  deleteNote: (i) ->
    @props.notes.splice [[i, 1]]

  render: ->
    notes = @props.notes.value.map (note, i) =>
      age = "#{note.age}," if note.age?
      sex = "#{note.sex}," if note.sex?

      <p key={i} className="note #{note.animal}">
        {note.animal}: {age} {sex} {note.behavior}
        {unless @props.step.value is steps.length - 1
          <button className="delete" onClick={@deleteNote.bind(null, i)}><img src="./assets/close-icon.svg" alt="X" /></button>}
      </p>

    <div className="notes-container">
      {<p className="note-hint">See something? Add an annotation and it will appear here!</p> unless @props.notes.value.length > 0}
      {notes}
    </div>

module.exports = Notes