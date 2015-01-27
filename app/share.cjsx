React = require 'react/addons'
cx = React.addons.classSet

Share = React.createClass
  displayName: 'Share'

  talkHref: ->
    domain = location.hostname.replace /^www\./, ''
    "http://talk.#{domain}/#/subjects/#{@props.zooniverseId}"

  render: ->
    socialTitle = 'Zooniverse classification'
    socialMessage = 'Classifying on the Zooniverse!'
    subjectVideo = @props.video

    status = "#{socialMessage} #{@talkHref()}"

    fbHref =
      """
        https://www.facebook.com/sharer/sharer.php
        ?s=100
        &p[url]=#{encodeURIComponent subjectVideo}
        &p[title]=#{encodeURIComponent socialTitle}
        &p[summary]=#{encodeURIComponent socialMessage}
        &p[images][0]=#{socialMessage}
      """.replace '\n', '', 'g'

    twitterHref =
      "http://twitter.com/home?status=#{encodeURIComponent status}"

    pinterestHref =
      """
        http://pinterest.com/pin/create/button/
        ?url=#{encodeURIComponent @talkHref()}
        &media=#{encodeURIComponent subjectVideo}
        &description=#{encodeURIComponent socialMessage}
      """.replace '\n', '', 'g'

    <div className="share">
      <p>Share this clip</p>
      <a target="_blank" href={fbHref}>
        <button ref="facebookBtn" className="share-btn" ><i className="fa fa-facebook fa-lg"></i></button>
      </a>
      <a target="_blank" href={twitterHref}>
        <button ref="twitterBtn" className="share-btn"><i className="fa fa-twitter fa-lg"></i></button>
      </a>
      <a target="_blank" href={pinterestHref}>
        <button ref="pinterestBtn" className="share-btn"><i className="fa fa-pinterest fa-lg"></i></button>
      </a>
      <a target="_blank" href={@talkHref()}>
        <button ref="discussBtn" className="discuss-btn" value="Discuss">Discuss on Talk</button>
      </a>
    </div>

module.exports = Share