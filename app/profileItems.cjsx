React = require 'react/addons'
cx = React.addons.classSet

Favorite = require 'zooniverse/models/favorite'
Recent = require 'zooniverse/models/recent'
User = require 'zooniverse/models/user'

_ = require 'underscore'

ProfileItem = React.createClass
  displayName: 'ProfileItem'

  render: ->
    <video poster={@prop.item.subjects[0]?.location.previews[0]} src={@prop.item.subjects[0]?.location.standard} width="33%" type="video/mp4" controls>
      Your browser does not support the video format. Please upgrade your browser.
    </video>

ProfileItems = React.createClass
  displayName: 'ProfileItems'

  getInitialState: ->
    recents: null
    favorites: null
    items: []
    isLoading: false

  componentDidMount: ->
    if User.current
      setTimeout ( =>
        Recent.fetch (recents) =>
          @setState recents: recents
        Favorite.fetch (favorites) =>
          @setState favorites: favorites
      ), 2000
      @getItems()

  buildItem: (start, end, currentCollection) ->
    items = []
    for i in [start..end] by 1
      currentCollection.map (item, i) =>
        items.push <ProfileItem key={i} item={item} />
    if @state.items?
      @setState items: items
    else
      items

  getItems: (collection) ->
    if User.current
      @setState isLoading: true
      setTimeout ( =>
        newItems = @buildItem(@state.items.length, @state.items.length + 6, @state[@props.collection])
        @setState({
          isLoading: false
          items: @state.items.concat(newItems)
        })
      ), 2000

  render: ->
    <div>
      {@state.items}
      {<div className="loading-spinner"><i className="fa fa-spinner fa-spin"></i></div> if @state.isLoading is true}
    </div>

module.exports = ProfileItems
