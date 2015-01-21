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
      'bird'
      'chimpanzee'
      'elephant'
      'forest buffalo'
      'gorilla'
      'hippopotamus'
      'human'
      'hyneas'
      'Jentik\'s duiker'
      'large duiker'
      'large ungulate'
      'leopard'
      'lion'
      'lizard'
      'medium red duiker'
      'other'
      'pangolin'
      'porcupine'
      'rodent'
      'small antelope'
      'small blue duiker'
      'small bodied monkey'
      'small cat'
      'warthog'
      'wild dogs'
      'zebra duiker'
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
      'aggression'
      'arboreal'
      'camera reaction'
      'carrying'
      'climbing'
      'cross-species interaction'
      'drinking/feeding'
      'drumming'
      'grooming'
      'nursing'
      'playing'
      'resting'
      'sex'
      'social interaction'
      'terrestrial'
      'tool usage'
      'traveling'
      'vocalizing'
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
    question: null
    options: [
      'Next Subject'
    ]

module.exports = [[stepOne], [stepTwo], [stepThree], [stepChimp, stepOther], [stepFinal]]