React = require 'react/addons'
cx = React.addons.classSet

Share = React.createClass
  displayName: 'Share'

  getInitialState: ->
    socialTitle: 'Zooniverse classification'
    socialMessage: 'Classifying on the Zooniverse!'

  getDefaultProps: ->
    zooniverseId: null
    video: null

  talkHref: ->
    domain = location.hostname.replace /^www\./, ''
    "http://talk.#{domain}/#/subjects/#{@props.zooniverseId}"

  twitterHref: ->
    status = "#{@state.socialMessage} #{@talkHref()}"
    "http://twitter.com/home?status=#{encodeURIComponent status}"

  facebookHref: ->
    """
      https://www.facebook.com/sharer/sharer.php
      ?s=100
      &p[url]=#{encodeURIComponent @props.video}
      &p[title]=#{encodeURIComponent @state.socialTitle}
      &p[summary]=#{encodeURIComponent @state.socialMessage}
      &p[images][0]=#{@state.socialMessage}
    """.replace '\n', '', 'g'

  pinterestHref: ->
    """
      http://pinterest.com/pin/create/button/
      ?url=#{encodeURIComponent @talkHref()}
      &media=#{encodeURIComponent @props.video}
      &description=#{encodeURIComponent @state.socialMessage}
    """.replace '\n', '', 'g'

  render: ->
    <div className="share">
      <p>Share this clip</p>
      <a target="_blank" href={@facebookHref()}>
        <button ref="facebookBtn" className="share-btn" ><i className="fa fa-facebook fa-lg"></i></button>
      </a>
      <a target="_blank" href={@twitterHref()}>
        <button ref="twitterBtn" className="share-btn"><i className="fa fa-twitter fa-lg"></i></button>
      </a>
      <a target="_blank" href={@pinterestHref()}>
        <button ref="pinterestBtn" className="share-btn"><i className="fa fa-pinterest fa-lg"></i></button>
      </a>
      <a target="chimptalksubject" href={@talkHref()}>
        <button ref="discussBtn" className="discuss-btn" value="Discuss"><i className="fa fa-comments fa-lg"></i>Discuss on Talk</button>
      </a>
    </div>

module.exports = Share