React = require 'react/addons'
cx = React.addons.classSet

ZooFooter = require 'zooniverse/controllers/footer'

$ = window.jQuery
$window = $(window)

window.DEFINE_ZOONIVERSE_PROJECT_LIST = (categories) ->
  $window.trigger 'get-zooniverse-project-list', [categories]

Footer = React.createClass
  displayName: 'Footer'

  projectScript: 'http://zooniverse-demo.s3-website-us-east-1.amazonaws.com/projects.js'

  getInitialState: ->
    categories: null

  componentWillMount: ->
    $window.on 'get-zooniverse-project-list', @onFetch

    @fetchProjects()

  fetchProjects: ->
    $.getScript @projectScript

  onFetch: (e, categories) ->
    @setState categories: categories

  render: ->
    <div id="footer" className="zooniverse-footer">
      <a href="https://www.zooniverse.org/" className="zooniverse-logo-container">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" className="zooniverse-logo" width="1em" height="1em">
          <g className="zooniverse-logo" fill="currentColor" stroke="transparent" strokeWidth="0" transform="translate(50, 50)">
            <path d="M 0 -45 A 45 45 0 0 1 0 45 A 45 45 0 0 1 0 -45 Z M 0 -30 A 30 30 0 0 0 0 30 A 30 30 0 0 0 0 -30 Z" />
            <path d="M 0 -12.5 A 12.5 12.5 0 0 1 0 12.5 A 12.5 12.5 0 0 1 0 -12.5 Z" />
            <path d="M 0 -75 L 5 0 L 0 75 L -5 0 Z" transform="rotate(50)" />
          </g>
        </svg>
      </a>

      <div className="zooniverse-footer-content">
        <div className="zooniverse-footer-heading">The Zooniverse is a collection of web-based citizen science projects that use the efforts of volunteers to help researchers deal with the flood of data that confronts them.</div>

        {if @state.categories?
          <div className="zooniverse-footer-projects">
            {for {category, projects}, i in @state.categories
              <div key={i} className="zooniverse-footer-category">
                <div className="zooniverse-footer-category-title">{category}</div>
                {for project, i in projects
                  <div key={i} className="zooniverse-footer-project">
                    <a href={project.url}>{project.name}</a>
                  </div>
                }
                <div className="zooniverse-footer-project"></div>
              </div>
            }
          </div>
        }

        <div className="zooniverse-footer-general">
          <div className="zooniverse-footer-category">
            <a href="https://www.zooniverse.org/privacy">Privacy Policy</a>
          </div>

          <div className="zooniverse-footer-category">
            <a href="https://github.com/zooniverse">Source & Bugs</a>
          </div>
        </div>
      </div>
    </div>

module.exports = Footer