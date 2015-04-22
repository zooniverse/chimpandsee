React = require 'react/addons'
cx = React.addons.classSet

Subject = require 'zooniverse/models/subject'
ProjectGroup = require 'zooniverse/models/project-group'
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
    group: null
    knownChimpsLink: null
    newChimpsLink: null

  componentDidMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[2] #chimp
        @setState chimpsSeen: true

    ProjectGroup.on 'fetch', @onProjectGroupFetch
    ProjectGroup.fetch()

  componentWillUnmount: ->
    ProjectGroup.off 'fetch', @onProjectGroupFetch

  onProjectGroupFetch: ->
    groupId = Subject.current.group_id
    group = ProjectGroup.find groupId
    @setState({
      group: group
      knownChimpsLink: group.metadata.known_chimps_link
      newChimpsLink: group.metadata.new_chimps_link
    }, => @getSiteLocation())

  getSiteLocation: ->
    locationName = @state.group.metadata.site

    siteLocation = switch
      when sites.siteA.indexOf(locationName) > -1 then "site-a"
      when sites.siteB.indexOf(locationName) > -1 then "site-b"
      when sites.siteC.indexOf(locationName) > -1 then "site-c"
      when sites.siteD.indexOf(locationName) > -1 then "site-d"

    @setState siteLocation: siteLocation

  render: ->
    noteSummary = @props.notes.map (note, i) =>
      plural = switch
          when note.animal is "hippopotamus" then "es"
          when note.animal is "cattle" then null
          else "s"

      <li key={i}>{if note.animal is "human" then "N/A" else note.number} {note.animal}{plural if note.number > 1 or note.number is "5+"}</li>

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
            <a href={@state.knownChimpsLink} target="allchimps"><button className="all-chimps-btn">Known chimps at this site</button></a>
          </div>
          <div className="chimp-btn-container">
            <a href={Subject.current.talkHref()} target="chimptalksubject"><button className="seen-chimp-btn">This is a known chimp!</button></a>
            <a href={@state.newChimpsLink} target="newchimp"><button className="new-chimp-btn">This is a new chimp!</button></a>
          </div>
        </section>
      }
    </div>

module.exports = Summary