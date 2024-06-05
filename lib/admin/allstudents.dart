import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddStudent.dart';
import 'package:assil_app/admin/profileetudient.dart';
import 'package:assil_app/teacher/student_service.dart';
import 'package:assil_app/teacher/student.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = StudentService.fetchAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Student>>(
            future: futureStudents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No students found.'));
              } else {
                return SingleChildScrollView(
                  child: Column(
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final student = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: StudentItem(
                              fullname: student.fullName,
                              currentYear: student.schoolYear,
                              image: student.profilePicture ?? 'assets/default_avatar.png',
                              onPressed: () {
                                // Navigate to student profile page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEtudiant(student: student),
                                  ),
                                );
                              },
                              onDelete: () {
                                // Implement delete functionality if needed
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
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
          ),
        ],
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
          // Show delete confirmation dialog
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
                    // Perform delete action
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
                    image: NetworkImage(image),
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
