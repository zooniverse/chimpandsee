React = require 'react/addons'

module?.exports = React.createClass
  displayName: 'Home'

  body: null
  video: null

  componentDidMount: ->
    if @props.hash is '#/'
      @body = document.getElementsByTagName('body')[0]
      @body.classList.add 'home-background'

    @video = document.getElementsByTagName('video')[0]
    @video.play()

  componentWillUnmount: ->
    @body.classList.remove 'home-background'
    @video.pause()

  render: ->
    <div className="home">
      <div className="color-overlay"></div>
      <div className="home-content">
        <h1><img className="logo" src="./assets/chimpnsee-logo.svg" alt="logo" /></h1>
        <p>Welcome to Africa&mdash;home of the chimpanzee.<br />Our cameras have taken thousands of videos of these and other animals.<br />
        Now we need your help to study, explore, and learn from them.</p>
        <a href="#/classify" className="get-started-link">Get Started</a>
        <a class="learn-more-link" href="http://talk.chimpandsee.org/#/boards/BCP000000c/discussions/DCP0000lrf">We're collecting the best clips of 2015!<br />Nominate your favorites and vote today!</a>
        <a href="#/about" className="learn-more-link">Learn More</a>
      </div>
    </div>
