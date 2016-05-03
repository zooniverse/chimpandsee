React = require 'react'
classnames = require 'classnames'

ProfileItems = require './profileItems'

signupDialog = require 'zooniverse/controllers/signup-dialog'
User = require 'zooniverse/models/user'

Profile = React.createClass
  displayName: 'Profile'

  usernameInput: ''
  passwordInput: ''

  getInitialState: ->
    collection: 'Recent'

  componentDidMount: ->
    @updateUser()

    User.on 'change', =>
      @onUserChange arguments...

    @onUserChange()

  onUserChange: (e, user) ->
    @usernameInput = @refs.username?.getDOMNode() || ''
    @passwordInput = @refs.password?.getDOMNode() || ''

    @usernameInput.value? user?.name || ''
    @passwordInput.value? user?.api_key || '' # Just for the dots.

  onClickSignUp: ->
    signupDialog.show()

  toggleCollection: (event) ->
    @setState collection: event.target.value

  updateUser: ->
    #Update the count if logged in
    if @props.user?
      User.fetch()

  userLogin: (e) ->
    e.preventDefault()

    login = User.login
      username: @usernameInput.value
      password: @passwordInput.value

    login.done ({success, message}) =>
      unless success
        @showError message

    login.fail =>
      @showError 'Sign in failed.'

  showError: (message) ->
    errorMessage = @refs.errorMessage

    errorMessage.getDOMNode().innerHTML = message

  render: ->
    recentClasses = classnames
      'active': @state.collection is 'Recent'

    favoriteClasses = classnames
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
          <form id="sign-in-form">
            <h3>Sign in to see your profile.</h3>
            <label><input ref="username" type="text" name="username" required="required" placeholder="Username"/></label>
            <label><input ref="password" type="password" name="password" required="required" placeholder="Password"/></label>
            <div ref="errorMessage" className="error-message"></div>
            <a className="forgot-password-link" href="https://www.zooniverse.org/password/reset" target="_blank">Forgot your password?</a>
            <div className="action"><button ref="signInButton" type="submit" onClick={@userLogin}>Sign in</button></div>
            <p className="no-account">{"Don't have an account?"} <a className="sign-up-link" onClick={@onClickSignUp} name="sign-up">Sign up</a></p>
          </form>
        </div>
      </section>

    <div className="profile">
      {userDetails}
    </div>

module.exports = Profile