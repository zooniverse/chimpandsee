React = require 'react/addons'
{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'About'

  render: ->
    <div className="about">
      <h1>About Page</h1>
      <nav>
        <Link to="about">About</Link>
        <Link to="team">Team</Link>
        <Link to="organizations">Organizations</Link>
      </nav>
    </div>