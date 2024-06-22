import 'dart:math';

import 'package:flutter/material.dart';
import 'package:assil_app/admin/class_service.dart';
import 'package:assil_app/admin/class.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
class ClassDetailsPage extends StatefulWidget {
  final String className;

  const ClassDetailsPage({Key? key, required this.className}) : super(key: key);

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {

  @override
  void initState() {
    super.initState();
    loadStudentImages();
  }


  List<String> classImages = [];

  Future<void> loadStudentImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/etudiant/'))
        .toList();
    setState(() {
      classImages = imagePaths;
    });
  }

  String getRandomStudentImage() {
    final random = Random();
    if (classImages.isNotEmpty) {
      final randomIndex = random.nextInt(classImages.length);
      return classImages[randomIndex];
    } else {
      return 'assets/default_image.png';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
      ),
      body: FutureBuilder<Class>(
        future: ClassService.fetchClassDetails(widget.className),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No class details found.'));
          } else {
            Class classDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Class Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classDetails.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Teacher: ${classDetails.teacher.first_name}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Students:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ...classDetails.students.map((student) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(getRandomStudentImage()),
                                ),
                                title: Text(student.fullName),
                                subtitle: Text('DOB: ${student.dateOfBirth}'),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
