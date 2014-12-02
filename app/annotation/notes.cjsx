React = require 'react/addons'
cx = React.addons.classSet
ImmutableOptimizations = require('react-cursor').ImmutableOptimizations

Notes = React.createClass
  displayName: 'Notes'

  mixins: [ImmutableOptimizations(['notes'])]

  deleteNote: (i) ->
    @props.notes.splice [[i, 1]]

  render: ->
    hintClasses = cx({
      'note-hint': true
      'hide': if @props.notes.value.length > 0 then true else false

    })

    notes = @props.notes.value.map (note, i) =>
      <div key={i} className="note-row">
        <p className="note">
          A(n) {note.age} {note.sex} {note.animal} is doing this behavior: {note.behavior}.
          <button className="delete" onClick={@deleteNote.bind(null, i)}>X</button>
        </p>
      </div>

    <div className="notes-container">
      <p className={hintClasses}>See something? Add an annotation and it will appear here!</p>
      {notes}
    </div>

module.exports = Notes