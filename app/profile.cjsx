React = require 'react/addons'
cx = React.addons.classSet

ProfileItems = require './profileItems'

loginDialog = require 'zooniverse/controllers/login-dialog'

Profile = React.createClass
  displayName: 'Profile'

  getInitialState: ->
    collection: 'Recent'

  onClickSignIn: ->
    loginDialog.show()

  toggleCollection: (event) ->
    @setState collection: event.target.value

  profileIsUpdated: ->
    @forceUpdate()

  render: ->
    recentClasses = cx({
      'active': @state.collection is 'Recent'
    })

    favoriteClasses = cx({
      'active': @state.collection is 'Favorite'
    })

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
            <button className={recentClasses} onClick={@toggleCollection} value="Recent">Recents</button>
            <button className={favoriteClasses} onClick={@toggleCollection} value="Favorite">Favorites</button>
            <ProfileItems collection={@state.collection} user={@props.user} updateUser={@props.updateUser} profileIsUpdated={@profileIsUpdated}/>
          </div>
        </section>
      </div>
    else
      <section className="profile-sign-in">
        <div className="content">
          <p>Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>
        </div>
      </section>

    <div className="profile">
      {userDetails}
    </div>

module.exports = Profile