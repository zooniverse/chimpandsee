React = require 'react/addons'
cx = React.addons.classSet

AnimateMixin = require "react-animate"

steps = require './lib/steps'

guideDetails = [{
    header: 'chimpanzee'
    subHeader: 'Pan Troglodytes'
    featureImage: 'http://placehold.it/360x230'
    description: 'The common chimpanzee (Pan troglodytes), also known as the robust chimpanzee, is a species of great ape. Colloquially, the common chimpanzee is often called the chimpanzee (or "chimp"), though this term can be used to refer to both species in the genus Pan: the common chimpanzee and the closely related bonobo, formerly called the pygmy chimpanzee. Evidence from fossils and DNA sequencing show both species of chimpanzees are the sister group to the modern human lineage.'
    exampleImages: ["./assets/example-1.jpg", "./assets/example-2.jpg", "./assets/example-3.jpg"]
  },

  {header: 'blah'}
]

Guide = React.createClass
  displayName: 'Guide'
  mixins: [AnimateMixin]

  getInitialState: ->
    guideDetailsIndex: null

  componentWillReceiveProps: ->
    if @props.guideIsOpen is false
      @setState guideDetailsIndex: null

  openAnimation: ->
    @animate "show-details", {transitionProperty: 'opacity, left', transitionDuration: '.15s, 0s', transitionDelay: '0s, 0s', opacity: '1', left: '0'}, {opacity: '0', left: '-400px'}, 'in-out', 500

  closeAnimation: ->
    @animate "close-details", {transitionProperty: 'opacity, left', transitionDuration: '.15s, 0s', transitionDelay: '0s, 0s', opacity: '0', left: '-400px'}, {opacity: '1', left: '0'}, 'in-out', 500

  onSelectGuideAnimal: (i) ->
    @openAnimation()
    @setState guideDetailsIndex: i

  onClickBack: ->
    @closeAnimation()
    @setState guideDetailsIndex: null

  onClickClose: ->
    @closeAnimation()
    @setState guideDetailsIndex: null
    @props.onClickClose()

  render: ->
    animals = steps[2][0].animal.options.map (animal, i) =>
      <li key={i} className="animal-list-item" onClick={@onSelectGuideAnimal.bind(null, i)}>{animal}</li>

    detailsClasses = cx({
      'details': true
      'hide': @state.guideDetailsIndex is null
    })

    headerClasses = cx({
      'guide-header': true
      'open-guide': @state.guideDetailsIndex isnt null
    })

    details = if @state.guideDetailsIndex?
      exampleImages = guideDetails[@state.guideDetailsIndex].exampleImages.map (image, i) =>
        <figure key={i}><img src={image} alt="Example image of an animal" /></figure>

      <section className={detailsClasses}>
        <button className="back-guide-btn" onClick={@onClickBack}><img className="back-icon" src="./assets/back-icon.svg" alt="back icon" /> Back</button>
        <h2>{guideDetails[@state.guideDetailsIndex].header}</h2>
        <h3>{guideDetails[@state.guideDetailsIndex].subHeader}</h3>
        <img src={guideDetails[@state.guideDetailsIndex].featureImage} />
        <p>{guideDetails[@state.guideDetailsIndex].description}</p>
        <figcaption>Example Images</figcaption>
        {exampleImages}
      </section>

    <div className="guide">
      <header className={headerClasses}>
        <button className="close-guide-btn" onClick={@onClickClose}>X</button>
        <h2>Field Guide</h2>
      </header>
      <nav style={if @state.guideDetailsIndex isnt null then @getAnimatedStyle("show-details") else @getAnimatedStyle("close-details")} className="animal-list">
        <header className="nav-header">What animal do you want to know about?</header>
        {animals}
      </nav>
      {details}
    </div>

module.exports = Guide