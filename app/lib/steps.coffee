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
      'Add Annotation'
      'Finish'
    ]

stepThree =
  animal:
    question: 'Which species do you want to annotate?'
    options: [
      'bird'
      'chimpanzee'
      'dark duiker'
      'elephant'
      'forest buffalo'
      'giant forest hog'
      'gorilla'
      'hippopotamus'
      'human'
      'hyena'
      'Jentik\'s duiker'
      'large ungulate'
      'leopard'
      'lion'
      'other'
      'other primate'
      'pangolin'
      'porcupine'
      'red duiker'
      'red river hog'
      'reptile'
      'rodent'
      'small antelope'
      'small grey duiker'
      'small cat'
      'warthog'
      'wild dog'
      'zebra duiker'
    ]

stepChimpAge =
  age:
    question: "What is its age?"
    options: [
      'youth'
      'adult'
    ]

stepChimpSex =
  sex:
    question: "What is its sex?"
    options: [
      'male'
      'female'
    ]

stepChimpBehavior =
  behavior:
    question: "What is this chimp doing?"
    options: [
      'aggression'
      'arboreal'
      'camera reaction'
      'carrying item'
      'carrying young'
      'climbing'
      'cross-species interaction'
      'drinking/feeding'
      'drumming'
      'grooming'
      'nursing'
      'playing'
      'resting'
      'sex/mounting'
      'social interaction'
      'terrestrial'
      'tool usage'
      'traveling'
      'vocalizing'
    ]

stepOther =
  behavior:
    question: "What is this animal doing and how many are there?"
    options: [
      'aggression'
      'arboreal'
      'camera reaction'
      'carrying item'
      'carrying young'
      'climbing'
      'cross-species interaction'
      'drinking/feeding'
      'drumming'
      'grooming'
      'nursing'
      'playing'
      'resting'
      'sex/mounting'
      'social interaction'
      'terrestrial'
      'tool usage'
      'traveling'
      'vocalizing'
    ]
  number:
    question: null
    options: [
      '1'
      '2'
      '3'
      '4'
      '5+'
    ]

stepFinal =
  summary:
    question: null
    options: [
      'Next Subject'
    ]

module.exports = [[stepOne], [stepTwo], [stepThree], [stepChimpAge, stepChimpSex, stepChimpBehavior, stepOther], [stepFinal]]