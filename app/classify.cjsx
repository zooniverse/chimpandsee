React = require 'react/addons'
Subject = require 'zooniverse/models/subject'
Annotation = require './annotation/annotation'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"
    preview: [
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
    ]
    showGuide: false

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect

  onSubjectSelect: (e, subject) ->
    @setState subject: subject.location.standard

  onClickGuide: (e) ->
    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    wrapper = document.getElementById('wrapper')

    if @state.showGuide is false
      @setState showGuide: true
      wrapper.classList.add 'push-right'
    else
      @setState showGuide: false
      wrapper.classList.remove 'push-right'

  onClickClose: ->
    wrapper = document.getElementById('wrapper')

    @setState showGuide: false
    wrapper.classList.remove 'push-right'

  render: ->
    <div className="classify">
      <div className="guide">
        <header>
          <h2>Field Guide</h2>
        </header>
        <section>
          <button className="close-guide-btn" onClick={@onClickClose}><img className="back-icon" src="./assets/back-icon.svg" alt="back icon" /> Back</button>
          <h2>Chimpanzee</h2>
          <h3>Pan Troglodytes</h3>
          <img src="http://placehold.it/360x230" />
          <p>The common chimpanzee (Pan troglodytes), also known as the robust chimpanzee, is a species of great ape. Colloquially, the common chimpanzee is often called the chimpanzee (or "chimp"), though this term can be used to refer to both species in the genus Pan: the common chimpanzee and the closely related bonobo, formerly called the pygmy chimpanzee. Evidence from fossils and DNA sequencing show both species of chimpanzees are the sister group to the modern human lineage.</p>
          <figcaption>Example Images</figcaption>
          <figure><img src="./assets/example-1.jpg" alt="Example of a chimp" /></figure>
          <figure><img src="./assets/example-2.jpg" alt="Example of a chimp" /></figure>
          <figure><img src="./assets/example-3.jpg" alt="Example of a chimp" /></figure>
        </section>
      </div>
      <Annotation subject={@state.subject} preview={@state.preview} onClickGuide={@onClickGuide} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
