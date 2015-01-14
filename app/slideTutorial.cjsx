React = require 'react/addons'
cx = React.addons.classSet

SlideTutorial = React.createClass
  displayName: 'SlideTutorial'

  getInitialState: ->
    general: [
      {image: 'http://placehold.it/560x280', title: 'Slide 1', content:'Slide 1', button: 'Next'}
      {image: 'http://placehold.it/560x280', title: 'Slide 2', content:'Slide 2', button: 'Next'}
      {image: 'http://placehold.it/560x280', title: 'Slide 3', content:'Slide 3', button: 'Finish'}
    ]
    chimps: [
      {image: 'http://placehold.it/560x280', title: 'Slide 1', content:'Chimp Slide 1', button: 'Next'}
      {image: 'http://placehold.it/560x280', title: 'Slide 2', content:'Chimp Slide 2', button: 'Next'}
      {image: 'http://placehold.it/560x280', title: 'Slide 3', content:'Chimp Slide 3', button: 'Finish'}
    ]
    activeSlide: 0

  componentWillReceiveProps: (nextProps) ->
    if nextProps.modalIsOpen is false
      @setState activeSlide: 0

  onClickButton: ->
    switch
      when @state.activeSlide < @state.slides.length - 1
        @setState activeSlide: @state.activeSlide + 1
      when @state.activeSlide is @state.slides.length - 1
        @props.onClickCloseSlide()

  onDotClick: (i) ->
    @setState activeSlide: i

  render: ->
    slideDots = @state[@props.tutorialType]?.map (slide, i) =>
      dotClasses = cx({
        'slide-tutorial-dot': true
        'active': i is @state.activeSlide
      })

      <div key={i} className={dotClasses} onClick={@onDotClick.bind(null, i)}></div>

    slides = @state[@props.tutorialType]?.map (slide, i) =>
      slideClasses = cx({
        'slide-tutorial-slide': true
        'active': i is @state.activeSlide
      })

      <div key={i} className={slideClasses}>
        <div className="slide-tutorial-slide-top">
          <img src={slide.image} />
        </div>
        <div className="slide-tutorial-slide-bottom">
          <h1>{slide.title}</h1>
          <p>{slide.content}</p>
        </div>
        <div className="slide-tutorial-button-container">
          <button className="slide-tutorial-next-button" onClick={@onClickButton} value={slide.button}>{slide.button}</button>
        </div>
        <div className="slide-tutorial-dots">
          {slideDots}
        </div>
      </div>

    slideTutorialClasses = cx({
      'slide-tutorial': true
      'show': @props.modalIsOpen
    })

    <div className={slideTutorialClasses}>
      <div  className="slide-tutorial-container">
        <button className="slide-tutorial-close-button" onClick={@props.onClickCloseSlide}>X</button>
        {slides}
      </div>
    </div>

module.exports = SlideTutorial