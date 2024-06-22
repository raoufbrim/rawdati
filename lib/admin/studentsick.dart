import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddStudent.dart';
import 'package:assil_app/admin/profilepredictionresult.dart'; // Importez le fichier ProfilePredictionResult
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionResult {
  final int id;
  final String studentFullName;
  final String result;
  final String disease;
  final String recommendation;

  PredictionResult({
    required this.id,
    required this.studentFullName,
    required this.result,
    required this.disease,
    required this.recommendation,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      id: json['id'],
      studentFullName: json['student_full_name'],
      result: json['result'],
      disease: json['disease'],
      recommendation: json['recommendation'],
    );
  }
}

class StudentSick extends StatefulWidget {
  @override
  _StudentSickState createState() => _StudentSickState();
}

class _StudentSickState extends State<StudentSick> {
  List<PredictionResult> _studentsWithTrouble = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentsWithTrouble();
  }

  Future<void> _fetchStudentsWithTrouble() async {
    final response = await http.get(Uri.parse('http://192.168.115.164:8000/students_with_trouble'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        _studentsWithTrouble = jsonResponse.map((data) => PredictionResult.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load students with trouble');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Les enfants atteints du trouble',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: _studentsWithTrouble.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the ProfilePredictionResult page with the selected student's data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePredictionResult(
                                student: _studentsWithTrouble[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  // Column for the profile picture (square)
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/default_avatar.png', // Remplacez ceci par le chemin d'image correct
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  // Column separated into 3 rows
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Row for name
                                        Row(
                                          children: [
                                            Text(
                                              '${_studentsWithTrouble[index].studentFullName}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        // Row for disease
                                        Row(
                                          children: [
                                            Text(
                                              _studentsWithTrouble[index].disease,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        // Row for recommendation
                                        Row(
                                          children: [
                                            Text(
                                              'Recommendation: ${_studentsWithTrouble[index].recommendation}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Smaller column for the ">" icon
                                  Column(
                                    children: [
                                      Icon(Icons.chevron_right, size: 24), // ">" icon
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddStudent())); // Action to perform when the button is pressed
              },
              backgroundColor: Color(0xFF40B7D5),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
