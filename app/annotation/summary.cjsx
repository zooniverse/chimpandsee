React = require 'react/addons'
cx = React.addons.classSet

Subject = require 'zooniverse/models/subject'
Share = require '../share'
steps = require '../lib/steps'

Summary = React.createClass
  displayName: 'Summary'

  getInitialState: ->
    chimpsSeen: false

  componentWillMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[1] #chimp
        @setState chimpsSeen: true

  render: ->
    noteSummary = @props.notes.map (note, i) =>
      <li key={i}>{note.number} {note.animal}{"s" if note.number > 1}</li>

    generalClasses = cx
      'general-summary': true
      'no-chimp': @state.chimpsSeen is false

    <div className="summary-content">
      <section className={generalClasses}>
        <div className="summary-location">
          <h3>At Location:</h3>
          <p>{@props.location}</p>
        </div>
        <div className="summary-notes">
          <h3>Your Classification Summary</h3>
          <ul>
            {noteSummary}
          </ul>
        </div>
        <Share video={@props.video.mp4} zooniverseId={@props.zooniverseId} />
      </section>
      <section className="map-container">
        <figure className="map"><img src="./assets/sample-map.png" alt="sample-map" /></figure>
      </section>
      {if @state.chimpsSeen is true
        <section className="chimp-summary">
          <img src="./assets/identified-chimp.gif" alt="An identified chimp" />
          <div className="chimp-content">
            <h3>Have you seen this chimp before?</h3>
            <p>Help us identify and name these chimps!</p>
          </div>
          <div className="chimp-btn-container">
            <button onClick={@props.openTutorial.bind(null, "chimps")}>Learn More</button>
            <button>Get Started</button>
            <button>Known Chimps</button>
          </div>
        </section>
      }
    </div>

module.exports = Summary