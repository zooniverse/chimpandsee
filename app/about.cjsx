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
        {header: "You can watch videos to help us learn about chimps and humans.", content: "For this project, we have collected nearly 7,000 hours of footage, reflecting various chimpanzee habitats, from camera traps in 15 countries across Africa. (We are also collecting a wide variety of organic samples from these sites, such as feces, hair, and plant matter, and information on the ecology and environment of each habitat.) By scanning the videos from these traps and identifying the types of species and activity that you see, you’ll help us to understand the lives of these apes—their behaviors, relationships, and environments—and to extrapolate new ideas about human origins.", image: "./assets/chimp-video.gif"},
        {header: "We have two goals: to learn and to preserve.", content: "In addition to helping us better understand cultural evolution, this project will also document wildlife populations and biodiversity in these areas. Already we have both documented new chimpanzee behaviors and made some startling finds of animals in locations where they were no longer thought to live! We hope that drawing attention to a great many of these sites will incite conservation organizations to take an interest in these areas and move to protect them.", image: "./assets/chimp-people.gif"}
        {header: "Ready to join us? Get started watching chimps!", content: "Start Watching", image: ""}
      ]
      [
        {header: "Christophe Boesch", content: "is Professor and Director of the Department of Primatology of the Max Planck Institute for Evolutionary Anthropology in Germany. He has been studying apes for over 40 years across Africa, having established both the Tai Chimpanzee Project in Cote d’Ivoire and the Loango Ape Project in Gabon during this time. His research takes a holistic approach to studying chimpanzees and uses this to improve our understanding of the evolution of humans and their cognitive and cultural abilities. He is the author of several popular books and as the founding president of the Wild Chimpanzee Foundation he fights for a better future for the remaining wild ape populations at a grassroots level.", image: ""}
        {header: "Hjalmar Kuehl", content: "is a Robert Bosch Junior Professor and research group leader at the German Centre for Integrative Biodiversity Research and the Max Planck Institute for Evolutionary Anthropology. His research has focused on various issues in ape conservation, the development of wildlife survey and monitoring techniques, as well as questions in ape population ecology. More recently he has been focusing on new approaches to reduce the negative effects of natural resource exploitation in great ape habitats and combining evidence-based environmental protection with complexity science.", image: ""}
        {header: "Mimi Arandjelovic", content: "is a junior scientist and project manager of the Pan African Programme: The Cultured Chimpanzee at the Max Planck Institute for Evolutionary Anthropology. Her research focuses on primate genetics, molecular ecology and conservation biology, and finding efficient means of studying wild animal populations non-invasively. In addition to her current research, she currently manages data collection from over 35 temporary research sites across Africa from all four chimpanzee subspecies.", image: ""}
      ]
      [
        {header: "Max Planck Institute for Evolutionary Anthropology", content: "The Max Planck Institute for Evolutionary Anthropology unites scientists with various backgrounds (natural sciences and humanities) whose aim is to investigate the history of humankind from an interdisciplinary perspective with the help of comparative analyses of genes, cultures, cognitive abilities, languages and social systems of past and present human populations as well as those of primates closely related to human beings.", image: ""}
        {header: "Zooniverse", content: "The Zooniverse and the suite of projects it contains is produced, maintained and developed by the Citizen Science Alliance. The member institutions of the CSA work with many academic and other partners around the world to produce projects that use the efforts and ability of volunteers to help scientists and researchers deal with the flood of data that confronts them.", image: ""}
      ]
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
        @state.pageContent[1].map (page, i) =>
          <section key={i} className="about-section">
            <p>
              <span className="name">{page.header}</span>
              {page.content}
            </p>
          </section>
      when @state.activeContent is 2
        @state.pageContent[2].map (page, i) =>
          <section key={i}>
            <h2>{page.header}</h2>
            <p>{page.content}</p>
          </section>

    pageClasses = cx({
      'page-one': @state.activeContent is 0
      'page-two content': @state.activeContent is 1
      'page-three content': @state.activeContent is 2
    })

    <div className="about">
      <section className="about-hero">
        <h2>About<br />Chimp<span className="amp">&</span>See</h2>
      </section>
      <nav className="about-nav">
        <div className="content">
          {links}
        </div>
      </nav>
      <section className={pageClasses}>
        {pageContent}
      </section>
    </div>