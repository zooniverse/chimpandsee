React = require 'react/addons'
cx = React.addons.classSet

ProfileItems = require './profileItems'

loginDialog = require 'zooniverse/controllers/login-dialog'

Profile = React.createClass
  displayName: 'Profile'

  getInitialState: ->
    collection: 'recents'

  onClickSignIn: ->
    loginDialog.show()

  toggleCollection: (event) ->
    @setState collection: event.target.value

  render: ->
    userDetails = if @props.user?
      <div>
        <h1>Hello, {@props.user.name}</h1>
        <p>Favorite: {@props.user.project.favorite_count or 0}</p>
        <p>Classification Count: {@props.user.project.classification_count or 0}</p>
        <button onClick={@toggleCollection} value="recents">Recents</button>
        <button onClick={@toggleCollection} value="favorites">Favorites</button>
        <ProfileItems collection={@state.collection} />
      </div>
    else
      <p>Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>

    <div className="profile content">
      {userDetails}
    </div>

module.exports = Profile