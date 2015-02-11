React = require 'react/addons'
cx = React.addons.classSet

ProfileItems = require './profileItems'

signupDialog = require 'zooniverse/controllers/signup-dialog'
User = require 'zooniverse/models/user'

Profile = React.createClass
  displayName: 'Profile'

  getInitialState: ->
    collection: 'Recent'

  componentDidMount: ->
    @updateUser()

  onClickSignUn: ->
    signupDialog.show()

  toggleCollection: (event) ->
    @setState collection: event.target.value

  updateUser: ->
    if @props.user?
      User.fetch()

  userLogin: ->
    console.log 'click'
    username = @refs.username.getDOMNode().value
    password = @refs.password.getDOMNode().value
    signInButton = @refs.signInButton.getDOMNode()

    login = User.login
      username: username
      password: password

    console.log login.done

    login.done ({success, message}) =>
      unless success
        @showError message

    login.fail =>
      console.log 'fail'

    login.always =>
      # @el.removeClass 'loading'
      setTimeout => signInButton.disabled = true if User.current?

  showError: (message) ->
    console.log message
    errorMessage = @refs.errorMessage

    errorMessage.getDOMNode().innerHTML = message

  render: ->
    recentClasses = cx
      'active': @state.collection is 'Recent'

    favoriteClasses = cx
      'active': @state.collection is 'Favorite'

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
            <ProfileItems collection={@state.collection} user={@props.user} updateUser={@updateUser} profileIsUpdated={@profileIsUpdated}/>
          </div>
        </section>
      </div>
    else
      <section className="profile-sign-in">
        <div className="content">
          <p>Please <a href="#/profile" onClick={@onClickSignIn}>sign in</a>.</p>
          <form id="sign-in-form">
            <h3>Sign in to see your profile.</h3>
            <label><input ref="username" type="text" name="username" required="required" placeholder="Username"/></label>
            <label><input ref="password" type="password" name="password" required="required" placeholder="Password"/></label>
            <div ref="errorMessage" className="error-message"></div>
            <div className="action"><button ref="signInButton" type="submit" onClick={@userLogin}>Sign in</button></div>
            <p className="no-account">{"Don't have an account?"} <button onClick={@onClickSignUp} name="sign-up">Sign up</button></p>
          </form>
        </div>
      </section>

    <div className="profile">
      {userDetails}
    </div>

module.exports = Profile