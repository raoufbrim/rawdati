import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddTeacher.dart';
import 'package:assil_app/admin/enseignant.dart';
import 'package:assil_app/admin/teacher_service.dart';

class AllTeachers extends StatefulWidget {
  const AllTeachers({Key? key}) : super(key: key);

  @override
  _AllTeachersState createState() => _AllTeachersState();
}

class _AllTeachersState extends State<AllTeachers> {
  late Future<List<Teacher>> teachers;

  @override
  void initState() {
    super.initState();
    teachers = TeacherService.fetchAllTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Teacher>>(
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final teacher = snapshot.data![index];
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
                                    setState(() {
                                      snapshot.data!.removeAt(index);
                                    });
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
                            teacher: teacher,
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
              );
            }
          },
        ),
      ),
    );
  }
}

class TeacherItem extends StatelessWidget {
  final Teacher teacher;

  const TeacherItem({Key? key, required this.teacher}) : super(key: key);

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
                  : Image.asset('assets/default_avatar.png', fit: BoxFit.cover),
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
