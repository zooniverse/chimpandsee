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
          <button>How to identify a chimp</button>
        </section>
      }
      <button value="Discuss">Discuss</button>
      <button>Share</button>
      <p>A map</p>
      <figure className="map"><img src="http://placehold.it/400x250" /></figure>
    </div>


module.exports = Summary