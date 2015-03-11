React = require 'react/addons'
cx = React.addons.classSet

Subject = require 'zooniverse/models/subject'
Share = require '../share'
steps = require '../lib/steps'

sites =
  siteA: ["Guinea_FoutahDjalon", "Guinea_Sangaredi", "GuineaBissau_Boe_Part1", "GuineaBissau_Boe_Part2", "IvoryCoast_Azagny", "IvoryCoast_Djouroutou", "IvoryCoast_TaiE", "IvoryCoast_TaiR", "Liberia_EastNimba", "Liberia_Grebo_Sala_part1", "Liberia_Grebo_Sala_part2", "Liberia_Grebo_Tasla", "Liberia_Sapo", "Senegal_Kayan"]
  siteB: ["Nigeria_Gashaka"]
  siteC: ["EquatorialGuinea_Nationwide"]
  siteD: ["DRC_BiliUere", "Uganda_Budongo", "Uganda_Bwindi", "Uganda_Ngogo", "Tanzania_Ugalla"]

Summary = React.createClass
  displayName: 'Summary'

  getInitialState: ->
    chimpsSeen: false
    siteLocation: null

  componentWillMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[1] #chimp
        @setState chimpsSeen: true

    @getSiteLocation()

  getSiteLocation: ->
    locationName = Subject.current.metadata.file.split('/')[2]

    siteLocation = switch
      when sites.siteA.indexOf(locationName) > -1 then "site-a"
      when sites.siteB.indexOf(locationName) > -1 then "site-b"
      when sites.siteC.indexOf(locationName) > -1 then "site-c"
      when sites.siteD.indexOf(locationName) > -1 then "site-d"

    @setState siteLocation: siteLocation

  render: ->
    noteSummary = @props.notes.map (note, i) =>
      <li key={i}>{note.number} {note.animal}{"s" if note.number > 1}</li>

    generalClasses = cx
      'general-summary': true
      'no-chimp': @state.chimpsSeen is false

    <div className="summary-content">
      <section className={generalClasses}>
        <div className="summary-location">
          <h3>At Location:</h3>
          <p>{@props.location}</p>
        </div>
        <div className="summary-notes">
          <h3>Your Classification Summary</h3>
          <ul>
            {noteSummary}
          </ul>
        </div>
        <Share video={@props.video.mp4} zooniverseId={Subject.current.zooniverse_id} />
      </section>
      <section className="map-container">
        <figure className="map"><img src={
          unless @state.siteLocation is null
            if @state.chimpsSeen is true
              "./assets/summary/chimp-#{@state.siteLocation}.jpg"
            else
              "./assets/summary/#{@state.siteLocation}.jpg"
          else
            "./assets/summary/sample-map.png"
          }
          alt="site location map" />
        </figure>
      </section>
      {if @state.chimpsSeen is true
        <section className="chimp-summary">
          <img src="./assets/summary/identified-chimp.gif" alt="An identified chimp" />
          <div className="chimp-content">
            <h3>Have you seen this chimp before?</h3>
            <p>Help us identify and name these chimps!</p>
            <button className="learn-more-btn" onClick={@props.openTutorial.bind(null, "chimps")}>How does this work?</button>
            <button className="all-chimps-btn">Known chimps at this site</button>
          </div>
          <div className="chimp-btn-container">
            <a href={Subject.current.talkHref()} target="chimptalksubject"><button className="seen-chimp-btn">This is a known chimp!</button></a>
            <button className="new-chimp-btn">This is a new chimp!</button>
          </div>
        </section>
      }
    </div>

module.exports = Summary