React = require 'react/addons'
cx = React.addons.classSet

Favorite = require 'zooniverse/models/favorite'
Recent = require 'zooniverse/models/recent'
User = require 'zooniverse/models/user'

ProfileItems = React.createClass
  displayName: 'ProfileItems'

  getInitialState: ->
    recents: null
    favorites: null

  componentWillMount: ->
    setTimeout ( =>
      if User.current
        Recent.fetch (recents) =>
          @setState recents: recents
        Favorite.fetch (favorites) =>
          @setState favorites: favorites
    ), 2000

  render: ->
    items = @state[@props.collection]?.map (item, i) =>
      <video key={i} poster={item.subjects[0]?.location.previews[0]} src={item.subjects[0]?.location.standard} width="33%" type="video/mp4" controls>
        Your browser does not support the video format. Please upgrade your browser.
      </video>

    <div>
      {<p>Loading...</p> if @state[@props.collection] is null}
      {items}
    </div>

module.exports = ProfileItems
