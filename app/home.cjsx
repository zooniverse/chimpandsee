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
      <figure className="left-chimp"><img src="./assets/left-chimp.png" alt="" /></figure>
      <div className="home-content">
        <h1>Chimp<span className="amp">&</span>See</h1>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        <a href="#/classify" className="get-started-link">Get Started</a>
        <a href="#/about" className="learn-more-link">Learn More</a>
      </div>
      <figure className="right-chimp"><img src="./assets/right-chimp.png" alt="" /></figure>
    </div>
