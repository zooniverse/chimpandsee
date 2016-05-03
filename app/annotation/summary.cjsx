React = require 'react'
classnames = require 'classnames'

Subject = require 'zooniverse/models/subject'
ProjectGroup = require 'zooniverse/models/project-group'
Api = require 'zooniverse/lib/api'
Share = require '../share'
steps = require '../lib/steps'

sites =
  siteA: ["guinea_foutahdjalon", "guinea_sangaredi", "guineabissau_boe_part1", "guineabissau_boe_part2", "ivorycoast_azagny", "ivorycoast_djouroutou", "ivorycoast_taie", "ivorycoast_tair", "liberia_eastnimba", "liberia_grebo_sala_part1", "liberia_grebo_sala_part2", "liberia_grebo_tasla", "liberia_sapo", "senegal_kayan", "liberia_grebo_part1", "taieast_marielyne"]
  siteB: ["nigeria_gashaka"]
  siteC: ["equatorialguinea_nationwide"]
  siteD: ["drc_biliuere", "uganda_budongo", "uganda_bwindi", "uganda_ngogo", "tanzania_ugalla"]

# Note: group metadata does not exist in dev db, so buttons and location image will not work locally or on staging
Summary = React.createClass
  displayName: 'Summary'

  getInitialState: ->
    chimpsSeen: false
    siteLocation: null
    group: null
    newChimpsLink: null

  componentDidMount: ->
    @props.notes.map (note) =>
      if note.animal is steps[2][0].animal.options[2] #chimp
        @setState chimpsSeen: true

    ProjectGroup.on 'fetch', @onProjectGroupFetch
    ProjectGroup.on 'fetch-fail', @onProjectGroupFail
    ProjectGroup.fetch()

  componentWillUnmount: ->
    ProjectGroup.off 'fetch', @onProjectGroupFetch
    ProjectGroup.off 'fetch-fail', @onProjectGroupFail

  onProjectGroupFetch: ->
    groupId = Subject.current?.group_id
    Api.current.get("/projects/#{Api.current.project}/groups/#{groupId}")
      .then (subjectGroup) =>
        @setState({
          group: subjectGroup
          newChimpsLink: subjectGroup.metadata.new_chimps_link
        }, => @getSiteLocation())

  onProjectGroupFail: ->
    console.error 'Project Group fetch failed'

  getSiteLocation: ->
    locationName = @state.group.metadata.site

    siteLocation = switch
      when sites.siteA.indexOf(locationName.toLowerCase()) > -1 then "site-a"
      when sites.siteB.indexOf(locationName.toLowerCase()) > -1 then "site-b"
      when sites.siteC.indexOf(locationName.toLowerCase()) > -1 then "site-c"
      when sites.siteD.indexOf(locationName.toLowerCase()) > -1 then "site-d"

    @setState siteLocation: siteLocation

  render: ->
    noteSummary = @props.notes.map (note, i) =>
      plural = switch
          when note.animal is "hippopotamus" then "es"
          when note.animal is "cattle" then null
          else "s"

      <li key={i}>{if note.animal is "human" then "N/A" else note.number} {note.animal}{plural if note.number > 1 or note.number is "5+"}</li>

    generalClasses = classnames
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
        <Share video={@props.video.mp4} zooniverseId={Subject.current?.zooniverse_id} />
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
          </div>
          <div className="chimp-btn-container">
            <a href="http://talk.chimpandsee.org/#/boards" target="allchimps"><button className="all-chimps-btn">All Chimp ID Boards</button></a>
            <a href={@state.newChimpsLink} target="newchimp"><button className="new-chimp-btn">Site Chimp ID Board</button></a>
          </div>
        </section>
      }
    </div>

module.exports = Summary