React = require 'react/addons'
cx = React.addons.classSet

loginDialog = require 'zooniverse/controllers/login-dialog'

Profile = React.createClass
  displayName: 'Profile'

  onClickSignIn: ->
    loginDialog.show()

  render: ->
    userDetails = if @props.user?
      <div>
        <h1>Hello, {@props.user.name}</h1>
        <p>Favorite: {@props.user.project.favorite_count or 0}</p>
        <p>Classification Count: {@props.user.project.classification_count or 0}</p>
      </div>
    else
      <p>Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>

    <div className="profile content">
      {userDetails}
    </div>

module.exports = Profile