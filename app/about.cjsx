React = require 'react/addons'
cx = React.addons.classSet

{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'About'

  getInitialState: ->
    links: [
      { href: "about", name: "About" }
      { href: "team", name: "Team" }
      { href: "organizations", name: "Organizations" }
    ]
    pageContent: [
      [
        {header: "Can chimpanzee behavior tell us more about the origins of humanity?", content: "Studies of human evolution often focus on the fossils and artifacts left by our early ancestors. However, we can also make inferences about human origins by studying our closest living relatives: chimpanzees, the great apes of West and Central Africa. Because humans and chimps are so closely related, patterns in chimpanzee behavior may tell us quite a bit about how the earliest hominids lived and evolved.", image: "./assets/about-1.png"},
        {header: "Many theories tie human evolution to meat-eating and tool use.", content: "It is thought that a major leap in the mental, physical, and cultural development of Homo sapiens was associated with increases in hunting, meat-eating, and the use of tools. We sometimes see similar human-like behaviors appear among diverse populations of today’s wild chimpanzees. If we study when, where, and how such behavior is more prominent, we can get a better idea of the evolutionary scenarios that led to the rise of our species.", image: "./assets/chimp-tools.gif"},
        {header: "You can watch videos to help us learn about chimps and humans.", content: "For this project, we have collected nearly 7,000 hours of footage, reflecting various chimpanzee habitats, from camera traps in 15 countries across Africa. (We are also collecting a wide variety of organic samples from these sites, such as feces, hair, and plant matter, and information on the ecology and environment of each habitat.) By scanning the videos from these traps and identifying the types of species and activity that you see, you’ll help us to understand the lives of these apes—their behaviors, relationships, and environments—and to extrapolate new ideas about human origins.", image: "http://placehold.it/222"},
        {header: "We have two goals: to learn and to preserve.", content: "In addition to helping us better understand cultural evolution, this project will also document wildlife populations and biodiversity in these areas. Already we have both documented new chimpanzee behaviors and made some startling finds of animals in locations where they were no longer thought to live! We hope that drawing attention to a great many of these sites will incite conservation organizations to take an interest in these areas and move to protect them.", image: "http://placehold.it/222"}
        {header: "Ready to join us? Get started watching chimps!", content: "Start Watching", image: ""}
      ]
      [{}]
      [{}]
    ]
    activeContent: 0

  onLinkClick: (i) ->
    @setState activeContent: i

  render: ->
    navLinkClasses = cx({
      'about-link': window.location.hash isnt '#/about'
    })

    links = @state.links.map (link, i) =>
      <Link key={i} to={link.href} className={navLinkClasses if link.href is 'about'} onClick={@onLinkClick.bind(null, i)}>{link.name}</Link>

    pageContent = switch
      when @state.activeContent is 0
        @state.pageContent[0].map (page, i) ->
          <section key={i} className="about-section">
            <div className="content">
              <div>
                <h2>{page.header}</h2>
                <p>{page.content}</p>
                <a href="#/classify">{page.content}</a>
              </div>
              <img src={page.image} alt="" />
            </div>
          </section>
      when @state.activeContent is 1
        <div>Team</div>
      when @state.activeContent is 2
        <div>Organizations</div>

    <div className="about">
      <section className="about-hero">
        <h2>About<br />Chimp<span className="amp">&</span>See</h2>
      </section>
      <nav className="about-nav">
        <div className="content">
          {links}
        </div>
      </nav>
      <section>
        {pageContent}
      </section>
    </div>