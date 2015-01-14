stepOne =
  presence:
    question: null
    options: [
      'Nothing here'
      'I see something'
    ]

stepTwo =
  annotation:
    question: null
    options: [
      'Nothing here'
      'Add'
      'Finish'
    ]

stepThree =
  animal:
    question: 'Which species do you want to annotate?'
    options: [
      'chimpanzee'
      'gorilla'
      'human'
      'small bodied monkey'
      'elephant'
      'bird'
      'warthog'
      'pangolin'
      'lion'
      'leopard'
      'small cat'
      'hyneas'
      'wild dogs'
      'hippopotamus'
      'small blue duiker'
      'zebra duiker'
      'Jentik\'s duiker'
      'medium red duiker'
      'large duiker'
      'forest buffalo'
      'large ungulate'
      'small antelope'
      'lizard'
      'rodent'
      'porcupine'
      'other'
    ]

stepChimp =
  age:
    question: "What is this chimpanzee doing?"
    options: [
      'youth'
      'adult'
    ]
  sex:
    question: null
    options: [
      'male'
      'female'
    ]
  behavior:
    question: null
    options: [
      'drinking'
      'feeding'
      'traveling'
      'fleeing'
      'sleeping'
      'sex'
      'nursing'
      'playing'
      'social interaction'
      'agonistic interaction'
      'hunting'
      'tool use'
      'vocalization'
      'carrying item'
    ]

stepOther =
  behavior:
    question: "What is this animal doing?"
    options: [
      'this'
      'that'
      'the other thing'
      'drinking'
      'feeding'
      'social interaction'
      'something else'
    ]

stepFinal =
  summary:
    question: "Would you like to explore more?"
    options: [
      'Next Subject'
    ]

module.exports = [[stepOne], [stepTwo], [stepThree], [stepChimp, stepOther], [stepFinal]]