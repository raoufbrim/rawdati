import 'package:assil_app/admin/allclass.dart';

import 'package:flutter/material.dart';
import '../teacher/StudentList.dart';
import 'Class_List.dart'; // Import ClassList if not already imported

class ClassDetailsPage extends StatelessWidget {
  final ClassList classDetails;

  const ClassDetailsPage({Key? key, required this.classDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.className),
      ),
      body: SingleChildScrollView(
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
              child: ClassItem(
                className: classDetails.className,
                numberOfStudents: classDetails.numberOfStudents,
                image: classDetails.image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Teacher',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display list of teachers for the selected class
            ListView.builder(
              shrinkWrap: true,
              itemCount: classDetails.teachers.length,
              itemBuilder: (context, index) {
                final teacher = classDetails.teachers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(teacher.image),
                  ),
                  title: Text(teacher.className),
                  subtitle:
                      Text('Number of Students: ${teacher.numberOfStudents}'),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Students',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display list of students for the selected class
            ListView.builder(
              shrinkWrap: true,
              itemCount: classDetails.students.length,
              itemBuilder: (context, index) {
                final student = classDetails.students[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(student.imagePath),
                  ),
                  title: Text(student.fullname),
                  subtitle: Text('DOB: ${student.dateOfBirth}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
