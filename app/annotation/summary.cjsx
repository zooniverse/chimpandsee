React = require 'react/addons'
cx = React.addons.classSet

steps = require '../lib/steps'

totals = {}

Summary = React.createClass
  displayName: 'Summary'

  getInitialState: ->
    chimpsSeen: false

  componentWillMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[1] #chimp
        @setState chimpsSeen: true

    @noteCount(@props.notes)

  noteCount: (notes) ->
    i = 0
    while i < notes.length
      if typeof (totals[notes[i].animal]) is "undefined"
        totals[notes[i].animal] = 1
      else
        totals[notes[i].animal]++
      i++

  render: ->
    noteSummary = for animal, count of totals
      <li key={animal}>{count} {animal}{"s" if count > 1}</li>

    generalClasses = cx({
      'general-summary': true
      'no-chimp': @state.chimpsSeen is false
    })

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
        <div className="share">
          <p>Share this clip</p>
          <button className="share-btn" ><i className="fa fa-facebook"></i></button>
          <button className="share-btn"><i className="fa fa-twitter"></i></button>
          <button className="share-btn"><i className="fa fa-vine"></i></button>
          <button className="discuss-btn" value="Discuss">Discuss on Talk</button>
        </div>
      </section>
      <section className="map-container">
        <figure className="map"><img src="./assets/sample-map.png" alt="sample-map" /></figure>
      </section>
      {if @state.chimpsSeen is true
        <section className="chimp-summary">
          <img src="./assets/named-chimp.png" alt="A named chimp" />
          <div className="chimp-content">
            <h3>Have you seen this chimp before?</h3>
            <p>Help us identify and name these chimps!</p>
          </div>
          <div className="chimp-btn-container">
            <button onClick={@props.openModal.bind(null, "chimps")}>Learn More</button>
            <button>Get Started</button>
            <button>Known Chimps</button>
          </div>
        </section>
      }
    </div>

module.exports = Summary