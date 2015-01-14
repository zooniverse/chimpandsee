React = require 'react/addons'
cx = React.addons.classSet

steps = require '../lib/steps'

Summary = React.createClass
  displayName: 'Summary'

  getInitialState: ->
    chimpsSeen: false

  componentWillMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[0] #chimp
        @setState chimpsSeen: true

  render: ->
    <div className="summary-content">
      {if @state.chimpsSeen is true
        <section>
          <p>You saw a chimp!</p>
          <button>Identify a chimp</button>
          <button>Current chimps at this site</button>
          <button onClick={@props.openModal.bind(null, "chimps")}>How to identify a chimp</button>
        </section>
      }
      <button value="Discuss">Discuss</button>
      <button>Share</button>
      <figure className="map"><img src="http://placehold.it/400x250text=a_map" /></figure>
    </div>

module.exports = Summary