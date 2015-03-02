React = require 'react/addons'
cx = React.addons.classSet

AboutPage = React.createClass
  displayName: 'AboutPage'

  render: ->
    pageClasses = cx
      'page-one': @props.activeContent is 0
      'page-two': @props.activeContent is 1
      'page-three': @props.activeContent is 2

    pageContent = @props.pageContent.map (page, i) =>
      listOne = if page.listOne?
        page.listOne.map (item, i) =>
          <li key={i}>
            <a href={item.link if item.link?} target="_blank">{item.title}</a>
          </li>

      listTwo = if page.listTwo?
        page.listTwo.map (item, i) =>
          <li key={i}>
            <a href={item.link if item.link?} target="_blank">{item.title}</a>
          </li>

      <section key={i} className="about-section">
        <div className="content">
          <img src={page.image} alt={page.imgAlt} />
          <div>
            <h2 className="name">{page.header}</h2>
            {<h3>{page.subHeader}</h3> if page.subHeader?}
            <p  dangerouslySetInnerHTML={{__html: page.content}}></p>
            <a href="#/classify">{page.content}</a>
          </div>
        </div>
        {if @props.activeContent is 2
          <div className="content about-org-lists">
            <div>
              <h3>{page.listHeaderOne}</h3>
              <ul>
                {listOne}
              </ul>
              <h3>{page.listHeaderTwo}</h3>
              <ul>
                {listTwo}
              </ul>
            </div>
          </div>}
      </section>

    <div className={pageClasses}>{pageContent}</div>

module.exports = AboutPage