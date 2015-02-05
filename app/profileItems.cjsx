React = require 'react/addons'
cx = React.addons.classSet

Favorite = require 'zooniverse/models/favorite'
Recent = require 'zooniverse/models/recent'
User = require 'zooniverse/models/user'

Share = require './share'

ProfileItems = React.createClass
  displayName: 'ProfileItems'

  getInitialState: ->
    items: []
    isLoading: false
    hasMore: true
    page: 1

  componentDidMount: ->
    if @props.user? and @state.items.length is 0
      @buildItems()
    @attachScrollListener()

  componentWillReceiveProps: (nextProps) ->
    @attachScrollListener()
    @setState
      items: []
      page: 1
      hasMore: true

    @getItems()

  buildItems: ->
    if @props.collection is 'Recent'
      Recent.fetch {page: @state.page, per_page: 6}, (recents) =>
        @updateItemsState(recents)
    else
      Favorite.fetch {page: @state.page, per_page: 6}, (favorites) =>
        @updateItemsState(favorites)

  updateItemsState: (newItems) ->
    if newItems.length
      @setState items: @state.items.concat newItems
      @attachScrollListener()
    else
      @setState hasMore: false

  getItems: ->
    @setState isLoading: true
    setTimeout ( =>
      @buildItems()
      @setState isLoading: false
    ), 2000

  scrollListener: ->
    scrollTop =
      if window.pageYOffset isnt undefined
        window.pageYOffset
      else
        (document.documentElement or document.body.parentNode or document.body).scrollTop

    if scrollTop >= document.body.clientHeight - window.innerHeight - 100
      @detachScrollListener()
      @setState page: @state.page + 1
      @getItems()

  attachScrollListener: ->
    window.addEventListener 'scroll', @scrollListener
    window.addEventListener 'resize', @scrollListener

  detachScrollListener: ->
    window.removeEventListener 'scroll', @scrollListener
    window.removeEventListener 'resize', @scrollListener

  componentWillUnmount: ->
    @detachScrollListener()

  unFavorite: (e) ->
    id = e.target.value
    favorite = Favorite.find id
    favorite.delete()
    @props.updateUser()

  render: ->
    items = @state.items.map (item, i) =>
      <figure key={i} className="profile-item">
        <video controls preload>
          <source src={item.subjects[0]?.location.standard.webm} type="video/webm" />
          <source src={item.subjects[0]?.location.standard.mp4 || item.subjects[0]?.location.standard} type="video/mp4" />
          Your browser does not support the video format. Please upgrade your browser.
        </video>
        <figcaption>
          {<button name="unfavorite" value={item.id} onClick={@unFavorite}>&times;</button> if @props.collection is 'Favorite'}
          <Share video={item.subjects[0]?.location.standard.mp4 || item.subjects[0]?.location.standard} zooniverseId={item.subjects[0]?.zooniverse_id} />
        </figcaption>
      </figure>

    <div>
      {items}
      {<div className="loading-spinner"><i className="fa fa-spinner fa-spin fa-2x"></i></div> if @state.isLoading is true}
      {<div><p>No more items.</p></div> if @state.hasMore is false}
    </div>

module.exports = ProfileItems
