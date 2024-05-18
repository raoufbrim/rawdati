// quiz_material.dart
class QuizData {
  static List<Map<String, dynamic>> quizQuestions = [
    {
      'category': 'Informations Générales',
      'questions': [
        {
          'question': 'quel est le nom de l\'enfant?',
          'input': true,
        },
        {
          'question': 'Quel est l\'âge de l\'enfant?',
          'input': true,
        },
        {
          'question': 'Combien de frères et sœurs a-t-il/elle?',
          'input': true,
        },
        {
          'question': 'Quel est le sexe de l\'enfant?',
          'options': ['Garçon', 'Fille'],
          'input': false,
        },
      ],
    },
    {
      'category': 'Compétences Linguistiques',
      'questions': [
        {
          'question': 'L\'enfant a-t-il un vocabulaire limité?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'L\'enfant a-t-il des difficultés à former des phrases?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'A-t-il des problèmes de prononciation?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'Le langage de l\'enfant est-il plus lent que la moyenne pour son âge?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
      ],
    },
    {
      'category': 'Comportement et Attention',
      'questions': [
        {
          'question': 'L\'enfant semble-t-il souvent agité?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'Est-il impulsif?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'L\'enfant a-t-il des difficultés à rester à sa place pendant les activités?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'Présente-t-il des signes d\'hyperactivité?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
      ],
    },
    {
      'category': 'Perceptions Sensorielles',
      'questions': [
        {
          'question': 'L\'enfant a-t-il des difficultés à entendre ou à voir?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'Utilise-t-il des dispositifs d\'aide tels que des lunettes ou des appareils auditifs?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'L\'enfant réagit-il moins aux stimuli que les autres enfants de son âge?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'A-t-il des problèmes connus de vision ou d\'audition?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
      ],
    },
    {
      'category': 'Apprentissage et Développement',
      'questions': [
        {
          'question': 'L\'enfant a-t-il un retard d\'apprentissage?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'A-t-il besoin de plus de temps pour comprendre de nouvelles choses?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'L\'enfant nécessite-t-il des méthodes d\'apprentissage alternatives?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'Ses performances académiques sont-elles inférieures à celles des autres enfants de son âge?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
      ],
    },
    {
      'category': 'Socialisation et Personnalité',
      'questions': [
        {
          'question': 'L\'enfant est-il réservé?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'Est-il timide?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question':
              'Évite-t-il les interactions sociales avec les autres enfants?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
        {
          'question': 'L\'enfant préfère-t-il jouer seul?',
          'options': ['Oui', 'Non'],
          'input': false,
        },
       
      ],
    },
    // Add more categories and questions here
  ];
}
