React = require 'react'
classnames = require 'classnames'

slideTutorials = require './lib/slideTutorials'

SlideTutorial = React.createClass
  displayName: 'SlideTutorial'

  getInitialState: ->
    general: slideTutorials.general
    chimps: slideTutorials.chimps
    activeSlide: 0

  componentWillReceiveProps: (nextProps) ->
    if nextProps.tutorialIsOpen is false
      @setState activeSlide: 0

  onClickButton: ->
    switch
      when @state.activeSlide < @state[@props.tutorialType]?.length - 1
        @setState activeSlide: @state.activeSlide + 1
      when @state.activeSlide is @state[@props.tutorialType]?.length - 1
        @onClickCloseTutorial()

  onClickCloseTutorial: ->
    slideTutorial = @refs.slideTutorial.getDOMNode()
    slideTutorial.classList.add 'fade-out' #css fade-out animation cause js animations aren't great in react yet.

    #Wait for animation
    setTimeout ( =>
      slideTutorial.classList.remove 'fade-out'
      @props.closeTutorial()
    ), 250

  onDotClick: (i) ->
    @setState activeSlide: i

  render: ->
    slideDots = @state[@props.tutorialType]?.map (slide, i) =>
      dotClasses = classnames
        'slide-tutorial-dot': true
        'active': i is @state.activeSlide

      <div key={i} className={dotClasses} onClick={@onDotClick.bind(null, i)}></div>

    slides = @state[@props.tutorialType]?.map (slide, i) =>
      slideClasses = classnames
        'slide-tutorial-slide': true
        'active': i is @state.activeSlide

      <div key={i} className={slideClasses}>
        <div className="slide-tutorial-slide-top">
          {<img src={slide.image} alt="" /> if slide.image?}
          {<h1>{slide.title}</h1> if @props.tutorialType is 'chimps'}
        </div>
        <div className="slide-tutorial-slide-bottom">
          {<h1>{slide.title}</h1> if @props.tutorialType is 'general'}
          <p>{slide.content}</p>
        </div>
        <div className="slide-tutorial-button-container">
          <button className="slide-tutorial-next-button" onClick={@onClickButton} value={slide.button}>{slide.button}</button>
        </div>
        <div className="slide-tutorial-dots">
          {slideDots}
        </div>
      </div>

    slideTutorialClasses = classnames
      'slide-tutorial': true
      'show': @props.tutorialIsOpen
      'chimps': @props.tutorialType is 'chimps'

    <div ref="slideTutorial" className={slideTutorialClasses}>
      <div  className="slide-tutorial-container">
        <button className="slide-tutorial-close-button" onClick={@onClickCloseTutorial}><img src="./assets/cancel-icon.svg" alt="cancel icon" /></button>
        {slides}
      </div>
    </div>

module.exports = SlideTutorial