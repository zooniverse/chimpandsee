React = require 'react/addons'
cx = React.addons.classSet

AnimateMixin = require "react-animate"

steps = require './lib/steps'

guideDetails = require './lib/guide'

Guide = React.createClass
  displayName: 'Guide'
  mixins: [AnimateMixin]

  guideContainer: null
  body: null

  getInitialState: ->
    guideDetailsIndex: null
    showBehaviorList: false

  componentDidMount: ->
    @guideContainer = @refs.guideContainer.getDOMNode()
    @body = document.getElementsByTagName('body')[0]

  componentWillReceiveProps: (nextProps) ->
    if nextProps.guideIsOpen is false
      @setState guideDetailsIndex: null

  openAnimation: ->
    @animate "show-details", {transitionProperty: 'opacity, left', transitionDuration: '.15s, 0s', transitionDelay: '0s, 0s', opacity: '1', left: '0'}, {opacity: '0', left: '-400px'}, 'in-out', 500

  closeAnimation: ->
    @animate "close-details", {transitionProperty: 'opacity, left', transitionDuration: '.15s, 0s', transitionDelay: '0s, 0s', opacity: '0', left: '-400px'}, {opacity: '1', left: '0'}, 'in-out', 500

  onSelectGuideAnimal: (i) ->
    @openAnimation()
    @setState guideDetailsIndex: i
    @guideContainer.scrollTop = 0

    #For iOS Safari
    @body.scrollTop = 0 if window.innerWidth < 401

  onClickBehaviorList: ->
    console.log 'click'
    @openAnimation()
    @setState showBehaviorList: true
    @guideContainer.scrollTop = 0
    @body.scrollTop = 0 if window.innerWidth < 401

  onClickBack: ->
    @closeAnimation()
    @setState
      guideDetailsIndex: null
      showBehaviorList: false

  onClickClose: ->
    @closeAnimation()
    @setState
      guideDetailsIndex: null
      showBehaviorList: false
    @props.onClickClose()

  render: ->
    animals = steps[2][0].animal.options.map (animal, i) =>
      <li key={i} className="animal-list-item" onClick={@onSelectGuideAnimal.bind(null, i)}>
        <span id="animal-#{i}" className="tooltip"></span>
        <span className="animal-name">{animal}</span>
      </li>

    behaviorDetailsClasses = cx
      'details': true
      'hide': @state.showBehaviorList is false

    detailsClasses = cx
      'details': true
      'hide': @state.guideDetailsIndex is null

    headerClasses = cx
      'guide-header': true
      'open-guide': @state.guideDetailsIndex isnt null or @state.showBehaviorList is true

    details =
      if @state.guideDetailsIndex?
        exampleImages = guideDetails[@state.guideDetailsIndex].exampleImages.map (image, i) =>
          <figure key={i}><img src={image} alt="Example image of an animal" /><figcaption>{guideDetails[@state.guideDetailsIndex].credit if guideDetails[@state.guideDetailsIndex].credit?}</figcaption></figure>

        <section className={detailsClasses}>
          <button className="back-guide-btn" onClick={@onClickBack}><img className="back-icon" src="./assets/back-icon.svg" alt="back icon" /> Back</button>
          <h2 className="animal-name">{guideDetails[@state.guideDetailsIndex].header}</h2>
          <h3 className="animal-taxonomy" dangerouslySetInnerHTML={{__html: guideDetails[@state.guideDetailsIndex].subHeader}}></h3>
          <p>{guideDetails[@state.guideDetailsIndex].description}</p>
          <h4 className="images-header">Example Images</h4>
          {exampleImages}
          {if @state.guideDetailsIndex is 1
            <div>
              <h4>Male</h4>
              <p>Males can be identified by the presence of testicles. Chimpanzees also posses calloused structures in their gluteal region (sometime referred to as ischial callosities). These calloused pads are most evident on the posterior of males (as they lack a swelling), are dark in color and often appear in the shape of a heart.</p>
              <figure><img src="./assets/guide/chimps-adult-male-1.jpg" alt="Example of male chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-male-2.jpg" alt="Example of male chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-male-3.jpg" alt="Example of male chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-male-4.jpg" alt="Example of male chimp" /></figure>
              <h4>Female</h4>
              <p>Females have a pink sexual swelling‎ on their posteriors that can be inflated or deflated depending on where they are in the estrous cycle. Females can often be differentiated based on their swellings.</p>
              <figure><img src="./assets/guide/chimps-adult-female-1.jpg" alt="Example of female chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-female-2.jpg" alt="Example of female chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-female-juvenile-1.jpg" alt="Example of female chimp" /></figure>
              <figure><img src="./assets/guide/chimps-adult-female-juvenile-2.jpg" alt="Example of female chimp" /></figure>
              <h4>Juvenile</h4>
              <p>Juveniles will often be smaller and have lighter faces; very young individuals will also have a white tuft of hair on their posteriors.</p>
              <figure><img src="./assets/guide/chimps-juvenile-1.jpg" alt="Example of juvenile chimp" /></figure>
              <figure><img src="./assets/guide/chimps-juvenile-2.jpg" alt="Example of juvenile chimp" /></figure>
              <figure><img src="./assets/guide/chimps-juvenile-3.jpg" alt="Example of juvenile chimp" /></figure>
              <figure><img src="./assets/guide/chimps-juvenile-4.jpg" alt="Example of juvenile chimp" /></figure>

            </div>
          }
        </section>
      else if @state.showBehaviorList is true
        <section className={behaviorDetailsClasses}>
          <button className="back-guide-btn" onClick={@onClickBack}><img className="back-icon" src="./assets/back-icon.svg" alt="back icon" /> Back</button>
          <h2 className="animal-name">Behaviors</h2>
          <p>Lorem Ipsum</p>
        </section>

    <div ref="guideContainer" className="guide">
      <header className={headerClasses}>
        <button className="close-guide-btn" onClick={@onClickClose}><img src="./assets/cancel-icon.svg" alt="cancel icon" /></button>
        <h2>Field Guide</h2>
      </header>
      <nav style={if @state.guideDetailsIndex isnt null or @state.showBehaviorList is true then @getAnimatedStyle("show-details") else @getAnimatedStyle("close-details")} className="animal-list">
        <header className="nav-header">What animal do you want to know about?</header>
        <li className="behavior-list-item" onClick={@onClickBehaviorList}>Behaviors</li>
        {animals}
      </nav>
      {details}
    </div>

module.exports = Guide