React = require 'react/addons'
cx = React.addons.classSet

AboutPage = React.createClass
  displayName: 'AboutPage'

  render: ->
    pageClasses = cx({
      'page-one': @props.activeContent is 0
      'page-two': @props.activeContent is 1
      'page-three': @props.activeContent is 2
    })

    pageContent = @props.pageContent.map (page, i) ->
      <section key={i} className="about-section">
        <div className="content">
          <img src={page.image} alt={page.header} />
          <div>
            <h2 className="name">{page.header}</h2>
            {<h3>{page.subHeader}</h3> if page.subHeader?}
            <p>{page.content}</p>
            <a href="#/classify">{page.content}</a>
          </div>
        </div>
      </section>

    <div className={pageClasses}>{pageContent}</div>

module.exports = AboutPage