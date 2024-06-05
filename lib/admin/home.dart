import 'package:flutter/material.dart';
import 'package:assil_app/admin/DetaillClass.dart';
import 'package:assil_app/admin/allclass.dart';
import 'package:assil_app/admin/allstudents.dart';
import 'package:assil_app/admin/allteachers.dart';
import 'package:assil_app/admin/profileetudient.dart';
import 'package:assil_app/teacher/student_service.dart';
import 'package:assil_app/teacher/student.dart';
import 'package:assil_app/admin/profiletech.dart';
import 'Class_List.dart';
import 'Teacher_List.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;

  const HomeScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlueSpace(),
            _buildHorizontalListView(
              "Class Category",
              ClassData.classes.length,
              (BuildContext context, int index) => ClassCategory(index: index),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllClass()),
                );
              },
            ),
            _buildHorizontalListView(
              "Teachers",
              TeacherData.teachers.length,
              (BuildContext context, int index) =>
                  TeacherCategory(index: index, userEmail: userEmail),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => allteachers()),
                );
              },
            ),
            FutureBuilder<List<Student>>(
              future: StudentService.fetchAllStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No students found.'));
                } else {
                  return _buildHorizontalListView(
                    "Students",
                    snapshot.data!.length,
                    (BuildContext context, int index) => StudentCard(
                        student: snapshot.data![index]),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllStudents()),
                      );
                    },
                    snapshot,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueSpace() {
    return Container(
      color: const Color(0xFF40B7D5),
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            right: 10,
            child: Image.asset(
              "assets/hob.png",
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hi Admin",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Good morning",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListView(
    String title,
    int itemCount,
    Widget Function(BuildContext, int) itemBuilder,
    VoidCallback seeAllCallback,
    [AsyncSnapshot<List<Student>>? snapshot]
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: seeAllCallback,
                child: Text("See All"),
              ),
            ],
          ),
        ),
        Container(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (snapshot != null && snapshot.hasData) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileEtudiant(student: snapshot.data![index]),
                      ),
                    );
                  },
                  child: itemBuilder(context, index),
                );
              } else {
                return itemBuilder(context, index);
              }
            },
          ),
        ),
      ],
    );
  }
}

class ClassCategory extends StatelessWidget {
  final int index;

  const ClassCategory({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myClass = ClassData.classes[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassDetailsPage(classDetails: myClass),
              ),
            );
          },
          child: Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  width: 185,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 176, 217, 227),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      myClass.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myClass.className,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            myClass.groupimg,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${myClass.numberOfStudents} Student${myClass.numberOfStudents != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeacherCategory extends StatelessWidget {
  final int index;
  final String userEmail;

  const TeacherCategory({Key? key, required this.index, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacher = TeacherData.teachers[index];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilTech(userEmail: userEmail),
              ),
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  width: 185,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 176, 217, 227),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      teacher.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.className,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            teacher.groupimg,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${teacher.numberOfStudents} Student${teacher.numberOfStudents != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEtudiant(student: student),
              ),
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  width: 185,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 176, 217, 227),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: student.profilePicture.isNotEmpty
                        ? Image.network(
                            student.profilePicture,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/default_avatar.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
