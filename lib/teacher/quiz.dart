import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:assil_app/teacher/quiz_material.dart';



class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentCategoryIndex = 0;
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    // Initialize selectedAnswers list with null values for each question
    QuizData.quizQuestions.forEach((category) {
      category['questions'].forEach((question) {
        selectedAnswers.add(null);
      });
    });
  }

  void nextCategory() {
    setState(() {
      if (currentCategoryIndex < QuizData.quizQuestions.length - 1) {
        currentCategoryIndex++;
      }
    });
  }

  void previousCategory() {
    setState(() {
      if (currentCategoryIndex > 0) {
        currentCategoryIndex--;
      }
    });
  }

  void selectAnswer(String? answer, int questionIndex) {
    setState(() {
      int index = calculateIndex(currentCategoryIndex, questionIndex);
      selectedAnswers[index] = answer;
    });
  }

  int calculateIndex(int categoryIndex, int questionIndex) {
    int index = 0;
    for (int i = 0; i < categoryIndex; i++) {
      index += (QuizData.quizQuestions[i]['questions'].length as int);
    }
    index += questionIndex;
    return index.toInt();
  }

   void calculateScore(BuildContext context) {
    // Calculate score logic goes here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('forum Completed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < QuizData.quizQuestions.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${QuizData.quizQuestions[i]['category']}:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      for (int j = 0;
                          j < QuizData.quizQuestions[i]['questions'].length;
                          j++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Question ${i + 1}.${j + 1}: ${QuizData.quizQuestions[i]['questions'][j]['question']} - ${selectedAnswers[calculateIndex(i, j)]}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void>  submitAnswers(BuildContext context) async {
  var url = Uri.parse('http://192.168.45.164:8000/predict');
  try {

    int age = selectedAnswers[1] != null ? int.parse(selectedAnswers[1]!) : 0;  // Utilisez une valeur par défaut ou gérez l'erreur
    int siblings = selectedAnswers[2] != null ? int.parse(selectedAnswers[2]!) : 0;  // Idem pour le 

    var response = await http.post(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    }, body: json.encode({
      'age': age, 
      'sexe': selectedAnswers[3] == 'Garçon', 
      'vocabulaire_limite': selectedAnswers[4] == 'Oui',
      'difficulte_formulation_phrases': selectedAnswers[5] == 'Oui',
      'prononciation_inexacte': selectedAnswers[6] == 'Oui',
      'ralentissement_langage': selectedAnswers[7] == 'Oui',
      'agite': selectedAnswers[8] == 'Oui',
      'impulsif': selectedAnswers[9] == 'Oui',
      'difficulte_rester_place': selectedAnswers[10] == 'Oui',
      'hyperactif': selectedAnswers[11] == 'Oui',
      'difficulte_entendre_voir': selectedAnswers[12] == 'Oui',
      'utilisation_dispositifs_aide': selectedAnswers[13] == 'Oui',
      'reaction_stimuli_diminuee': selectedAnswers[14] == 'Oui',
      'problemes_vision_audition': selectedAnswers[15] == 'Oui',
      'retard_apprentissage': selectedAnswers[16] == 'Oui',
      'besoin_temps_comprendre': selectedAnswers[17] == 'Oui',
      'besoin_methodes_alternatives': selectedAnswers[18] == 'Oui',
      'faible_performance_academique': selectedAnswers[19] == 'Oui',
      'reserve': selectedAnswers[20] == 'Oui',
      'timide': selectedAnswers[21] == 'Oui',
      'evite_interactions_sociales': selectedAnswers[22] == 'Oui',
      'prefere_etre_seul': selectedAnswers[23] == 'Oui',
      'nombre_freres_soeurs': siblings // Remplacer par l'indice correct
    }));
     void showRecommendationDialog(BuildContext context, String recommendation) {
        List<String> recommendationList = recommendation.split(',');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Recommandations'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommendationList.map((rec) => Text("• $rec")).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                ),
              ],
            );
          },
        );
      }

    if (response.statusCode == 200) {
  var result = json.decode(response.body);

  // Première boîte de dialogue pour résultat et maladie
  showDialog(
    context: context,
    barrierDismissible: false,  // L'utilisateur doit cliquer sur un bouton pour fermer la boîte de dialogue
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Résultat du formulaire'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Résultat: ${result['result']}'),
              Text('Trouble: ${result['maladie']}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Voir les recommandations'),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la première boîte de dialogue
              showRecommendationDialog(context, result['recommendation']); // Montre les recommandations
            },
          ),
          TextButton(
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
} else {
  throw Exception('Failed to load data from API');
}
  } catch (e) {
    // Gérer les erreurs de connexion ou les exceptions ici
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('form Page'),
        backgroundColor: Colors.white, // Set white background color
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LinearProgressIndicator(
                  value: (currentCategoryIndex + 1) /
                      QuizData.quizQuestions.length,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '${QuizData.quizQuestions[currentCategoryIndex]['category']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: QuizData
                    .quizQuestions[currentCategoryIndex]['questions'].length,
                itemBuilder: (BuildContext context, int index) {
                  var question = QuizData.quizQuestions[currentCategoryIndex]
                      ['questions'][index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: ${question['question']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (question['options'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (question['options'] as List<String>)
                              .map((option) {
                            return RadioListTile(
                              title: Text(option),
                              value: option,
                              groupValue: selectedAnswers[
                                  calculateIndex(currentCategoryIndex, index)],
                              onChanged: (value) {
                                selectAnswer(value as String, index);
                              },
                            );
                          }).toList(),
                        ),
                      if (question['input'] ?? false)
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.grey[200], // Set grey background color
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Set shadow color
                                spreadRadius: 3, // Set spread radius
                                blurRadius: 5, // Set blur radius
                                offset: Offset(0, 3), // Set offset
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0.0),
                            child: TextField(
                              onChanged: (text) => selectAnswer(text, index),
                              decoration: InputDecoration(
                                labelText: '   Your Answer',
                                border:
                                    InputBorder.none, // Remove default border
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: previousCategory,
                ),
                Container(
                  height: 50,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentCategoryIndex <
                          QuizData.quizQuestions.length - 1) {
                        nextCategory();
                      } else {
                        calculateScore(context);
                        submitAnswers(context);
                      }
                    },
                    child: Text(
                      currentCategoryIndex < QuizData.quizQuestions.length - 1
                          ? 'Next'
                          : 'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
