React = require 'react/addons'

module?.exports = React.createClass
  displayName: 'Home'

  componentDidMount: ->
    if @props.hash is '#/'
      body = document.getElementsByTagName 'body'
      body[0].classList.add 'home-background'

  componentWillUnmount: ->
    body = document.getElementsByTagName 'body'
    body[0].classList.remove 'home-background'

  render: ->
    <div className="home">
      <div className="color-overlay"></div>
      <div className="home-content">
        <h1><img className="logo" src="./assets/chimpnsee-logo.svg" alt="logo" /></h1>
        <p>Welcome to Africa&mdash;home of the chimpanzee.<br />Our cameras have taken thousands of videos of these and other animals.<br />
        Now we need your help to study, explore, and learn from them.</p>
        <a href="#/classify" className="get-started-link">Get Started</a>
        <a href="#/about" className="learn-more-link">Learn More</a>
      </div>
    </div>
