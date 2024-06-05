import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddTeacher.dart';
import 'package:assil_app/admin/Teacher_List.dart';

class allteachers extends StatefulWidget {
  const allteachers({Key? key}) : super(key: key);

  @override
  _allteachersState createState() => _allteachersState();
}

class _allteachersState extends State<allteachers> {
  List<TeacherList> teachersList = TeacherData.teachers.toList();

  void deleteTeacher(int index) {
    setState(() {
      teachersList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: teachersList.length,
              itemBuilder: (context, index) {
                final teacher = teachersList[index];
                return GestureDetector(
                  onLongPress: () {
                    // Show confirmation dialog before deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm Deletion"),
                        content: Text(
                            "Are you sure you want to delete this teacher?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Delete the teacher from the list
                              deleteTeacher(index);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TeacherItem(
                      className: teacher.className,
                      numberOfTeachers: teacher.numberOfStudents,
                      image: teacher.image,
                    ),
                  ),
                );
              },
            ),
            Padding(
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
          ],
        ),
      ),
    );
  }
}

class TeacherItem extends StatelessWidget {
  final String className;
  final int numberOfTeachers;
  final String image;

  const TeacherItem({
    required this.className,
    required this.numberOfTeachers,
    required this.image,
  });

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
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            // Column for teacher details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for teacher name (class name)
                  Row(
                    children: [
                      Text(
                        className,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Row for number of teachers
                  Row(
                    children: [
                      Text(
                        '$numberOfTeachers Teachers',
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
            // Icon for navigation
            Column(
              children: [
                Icon(Icons.chevron_right, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
