import 'package:assil_app/teacher/quiz.dart';
import 'package:flutter/material.dart';

class form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 174, 239, 255), // Blue background color
      appBar: AppBar(
        title: Text('Formulaire Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'assets/formulaire.png', // Path to your photo
              width: 200, // Adjust according to your preference
              height: 250, // Adjust according to your preference
            ),
          ),
          SizedBox(height: 0), // Reduce spacing between the image and button
          Container(
            width: double.infinity,
            height: 50, // Reduce the height of the button
            margin: EdgeInsets.symmetric(
                horizontal: 100, vertical: 10), // Adjust margin
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                ),
              ),
              child: Text(
                'Start',
                style: TextStyle(fontSize: 16), // Reduce the text size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
