React = require 'react/addons'
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

Notes = React.createClass
  displayName: 'Notes'

  mixins: [ImmutableOptimizations(['notes'])]

  deleteNote: (i) ->
    @props.notes.splice [[i, 1]]

  render: ->
    notes = @props.notes.value.map (note, i) =>
      <div key={i} className="note-row">
        <p className="note">{note.number} {note.animal}(s) during the {note.time} facing the {note.view}.</p>
        <button className="delete" onClick={@deleteNote.bind(null, i)}>X</button>
      </div>

    <div className="notes-container">
      {notes}
    </div>

module.exports = Notes