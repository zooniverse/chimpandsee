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
        <section className="profile-status">
          <div className="content">
            <h1 className="greeting">Hello, {@props.user.name}</h1>
            <div className="classification-count">
              <p>{@props.user.project.classification_count or 0}</p>
              <p>Videos Explored</p>
            </div>
            <div className="favorite-count">
              <p>{@props.user.project.favorite_count or 0}</p>
              <p>Favorite Count</p>
            </div>
          </div>
        </section>
        <section className="items">
          <div className="content">
            <button onClick={@toggleCollection} value="recents">Recents</button>
            <button onClick={@toggleCollection} value="favorites">Favorites</button>
            <ProfileItems collection={@state.collection} />
          </div>
        </section>
      </div>
    else
      <section className="profile-sign-in">
        <p className="content">Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>
      </section>

    <div className="profile">
      {userDetails}
    </div>

module.exports = Profile