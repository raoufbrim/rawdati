import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddTeacher.dart';
import 'package:assil_app/admin/enseignant.dart';
import 'package:assil_app/admin/teacher_service.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllTeachers extends StatefulWidget {
  const AllTeachers({Key? key}) : super(key: key);

  @override
  _AllTeachersState createState() => _AllTeachersState();
}

class _AllTeachersState extends State<AllTeachers> {
  late Future<List<Teacher>> teachers;
  List<String> teacherImages = [];

  @override
  void initState() {
    super.initState();
    teachers = TeacherService.fetchAllTeachers();
    loadTeacherImages();
  }

  Future<void> loadTeacherImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/enseignant/'))
        .toList();
    setState(() {
      teacherImages = imagePaths;
    });
  }

  String getRandomTeacherImage() {
    final random = Random();
    if (teacherImages.isNotEmpty) {
      final randomIndex = random.nextInt(teacherImages.length);
      return teacherImages[randomIndex];
    } else {
      return 'assets/default_avatar.png';
    }
  }

  void deleteTeacher(int index, int teacherId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.115.164:8000/users/$teacherId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        teachers.then((teacherList) => teacherList.removeAt(index));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete teacher')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: FutureBuilder<List<Teacher>>(
        future: teachers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teachers found.'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for teacher',
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
                      'All teachers',
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
                      final teacher = snapshot.data![index];
                      final imageUrl = getRandomTeacherImage();
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TeacherItem(
                          teacher: teacher,
                          image: imageUrl,
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text("Are you sure you want to delete this teacher?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteTeacher(index, teacher.id); // Supprimer l'enseignant
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                          onPressed: () {
                            // Add navigation logic if needed
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF40B7D5),
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTeacher()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TeacherItem extends StatelessWidget {
  final Teacher teacher;
  final String image;
  final VoidCallback onDelete;
  final VoidCallback onPressed;

  const TeacherItem({
    Key? key,
    required this.teacher,
    required this.image,
    required this.onDelete,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Container for teacher image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: teacher.profilePicture.isNotEmpty
                  ? Image.network(teacher.profilePicture, fit: BoxFit.cover)
                  : Image.asset(image, fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            // Column for teacher details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for teacher name
                  Row(
                    children: [
                      Text(
                        '${teacher.firstName} ${teacher.lastName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Row for teacher email
                  Row(
                    children: [
                      Text(
                        teacher.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onPressed,
              child: Icon(
                Icons.chevron_right,
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
    );
  }
}
