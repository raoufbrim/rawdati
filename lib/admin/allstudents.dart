import 'dart:math';
import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddStudent.dart';
import 'package:assil_app/admin/profileetudient.dart';
import 'package:assil_app/teacher/student_service.dart';
import 'package:assil_app/teacher/student.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  late Future<List<Student>> futureStudents;
  List<String> studentImages = [];

  @override
  void initState() {
    super.initState();
    futureStudents = StudentService.fetchAllStudents();
    loadStudentImages();
  }

  void deleteStudent(int index, int studentId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.115.164:8000/students/$studentId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureStudents.then((students) => students.removeAt(index));
      });
    } else {
      // Affichez un message d'erreur si la suppression échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student')),
      );
    }
  }

  Future<void> loadStudentImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/etudiant/'))
        .toList();
    setState(() {
      studentImages = imagePaths;
    });
  }

  String getRandomStudentImage() {
    final random = Random();
    if (studentImages.isNotEmpty) {
      final randomIndex = random.nextInt(studentImages.length);
      return studentImages[randomIndex];
    } else {
      return 'assets/default_avatar.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: FutureBuilder<List<Student>>(
        future: futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found.'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for student',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All students',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final student = snapshot.data![index];
                      final imageUrl = getRandomStudentImage();
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: StudentItem(
                          fullname: student.fullName,
                          currentYear: student.schoolYear,
                          image: imageUrl,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEtudiant(student: student),
                              ),
                            );
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text("Are you sure you want to delete this student?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteStudent(index, student.id); // Supprimer l'étudiant
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF40B7D5),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudent(),
            ),
          );
        },
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  final String fullname;
  final String currentYear;
  final String image;
  final VoidCallback onPressed;
  final VoidCallback onDelete;

  const StudentItem({
    required this.fullname,
    required this.currentYear,
    required this.image,
    required this.onPressed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Confirm Deletion"),
              content: Text("Are you sure you want to delete this student?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete"),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(image),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Year: $currentYear',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onPressed,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.green,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
