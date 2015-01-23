React = require 'react/addons'
cx = React.addons.classSet

Favorite = require 'zooniverse/models/favorite'
Recent = require 'zooniverse/models/recent'
User = require 'zooniverse/models/user'

ProfileItems = React.createClass
  displayName: 'ProfileItems'

  getInitialState: ->
    items: []
    isLoading: false
    hasMore: true
    page: 1
    showCaption: false
    video: null

  componentDidMount: ->
    if @props.user?
      @buildItems()
    @attachScrollListener()

  componentWillReceiveProps: (nextProps) ->
    @attachScrollListener()
    @setState({
      items: []
      page: 1
      hasMore: true
    })
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
    # @scrollListener()

  detachScrollListener: ->
    window.removeEventListener 'scroll', @scrollListener
    window.removeEventListener 'resize', @scrollListener

  componentWillUnmount: ->
    @detachScrollListener()

  toggleCaption: (i) ->
    @setState({
      showCaption: !@state.showCaption
      video: i
    })

  unFavorite: (e) ->
    id = e.target.value
    favorite = Favorite.find id
    favorite.delete()
    @forceUpdate()

  render: ->
    items = @state.items.map (item, i) =>
      captionClasses = cx({
        'show': @state.showCaption is true and @state.video is i
      })
      <figure key={i} onMouseEnter={@toggleCaption.bind(null, i)} onMouseLeave={@toggleCaption}>
        <video poster={item.subjects[0]?.location.previews[0][0]} src={item.subjects[0]?.location.standard} type="video/mp4" controls>
          Your browser does not support the video format. Please upgrade your browser.
        </video>
        <figcaption className={captionClasses}>
          {<button name="unfavorite" value={item.id} onClick={@unFavorite}>&times;</button> if @props.collection is 'Favorite'}
          <a href="talk">Talk</a>
        </figcaption>
      </figure>

    <div>
      {items}
      {<div className="loading-spinner"><i className="fa fa-spinner fa-spin fa-2x"></i></div> if @state.isLoading is true}
      {<div><p>No more items.</p></div> if @state.hasMore is false}
    </div>

module.exports = ProfileItems
