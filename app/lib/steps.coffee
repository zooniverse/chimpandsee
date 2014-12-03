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
      '+'
      'Next subject'
    ]

stepThree =
  animal:
    question: 'Which species do you want to annotate?'
    options: [
      'chimpanzee'
      'gorilla'
      'bird'
      'rodent'
      'elephant'
      'monkey'
      'bonobo'
      'human'
      'leopard'
      'tiger'
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
  otherAnimal:
    question: "What is this animal doing?"
    options: [
      'this'
      'that'
    ]


module.exports = [stepOne, stepTwo, stepThree, stepChimp, stepOther]