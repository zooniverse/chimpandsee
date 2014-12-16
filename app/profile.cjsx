React = require 'react/addons'
cx = React.addons.classSet

Profile = React.createClass
  displayName: 'Profile'

  render: ->
    userDetails = if @props.user?
      <h1>Hello, {@props.user.name}</h1>
    else
      <p>Please sign in.</p>
    <div className="profile content">
      {userDetails}
    </div>

module.exports = Profile