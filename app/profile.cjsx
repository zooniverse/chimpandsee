React = require 'react/addons'
cx = React.addons.classSet

loginDialog = require 'zooniverse/controllers/login-dialog'

Profile = React.createClass
  displayName: 'Profile'

  onClickSignIn: ->
    loginDialog.show()

  render: ->
    userDetails = if @props.user?
      <h1>Hello, {@props.user.name}</h1>
    else
      <p>Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>

    <div className="profile content">
      {userDetails}
    </div>

module.exports = Profile