stepOne =
  presence:
    question: ''
    options: [
      'Nothing here'
      'Add Annotation'
    ]

stepTwo =
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

stepThree =
  age:
    question: 'Age?'
    options: [
      'youth'
      'adult'
    ]
  sex:
    question: 'Sex?'
    options: [
      'male'
      'female'
    ]
  behavior:
    question: "What is the animal doing?"
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

module.exports = [stepOne, stepTwo, stepThree]