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
      age = "#{note.age}," if note.age?
      sex = "#{note.sex}," if note.sex?

      <p key={i} className="note #{note.animal}">
        {note.animal}: {age} {sex} {note.behavior}
        <button className="delete" onClick={@deleteNote.bind(null, i)}><img src="./assets/close-icon.svg" alt="X" /></button>
      </p>

    <div className="notes-container">
      <p className={hintClasses}>See something? Add an annotation and it will appear here!</p>
      {notes}
    </div>

module.exports = Notes