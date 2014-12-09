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

  onSelectGuideAnimal: (i) ->
    @animate "show-details", {opacity: '1'}, {opacity: '0'}, 'in-out', 500
    @setState guideDetailsIndex: i

  render: ->
    animals = steps[2][0].animal.options.map (animal, i) =>
      <li key={i} className="animal-list-item" onClick={@onSelectGuideAnimal.bind(null, i)}>{animal}</li>

    detailsClasses = cx({
      'details': true
      'hide': @state.guideDetailsIndex is null
    })

    details = if @state.guideDetailsIndex?
      exampleImages = guideDetails[@state.guideDetailsIndex].exampleImages.map (image, i) =>
        <figure key={i}><img src={image} alt="Example image of an animal" /></figure>

      <section className={detailsClasses}>
        <button className="close-guide-btn" onClick={@props.onClickClose}><img className="back-icon" src="./assets/back-icon.svg" alt="back icon" /> Back</button>
        <h2>{guideDetails[@state.guideDetailsIndex].header}</h2>
        <h3>{guideDetails[@state.guideDetailsIndex].subHeader}</h3>
        <img src={guideDetails[@state.guideDetailsIndex].featured} />
        <p>{guideDetails[@state.guideDetailsIndex].description}</p>
        <figcaption>Example Images</figcaption>
        {exampleImages}
      </section>

    <div className="guide">
      <header>
        <h2>Field Guide</h2>
      </header>
      <nav style={@getAnimatedStyle("show-details")} className="animal-list">
        <header>What animal do you want to know about?</header>
        {animals}
      </nav>
      {details}
    </div>

module.exports = Guide