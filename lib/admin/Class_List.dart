import 'package:assil_app/teacher/StudentList.dart';

import 'Teacher_List.dart'; // Import TeacherList if not already imported

class ClassList {
  final String className;
  final int numberOfStudents;
  final String image;
  final String groupimg;
  final List<TeacherList> teachers; // Add list of teachers
  final List<Students> students; // Add list of students

  ClassList({
    required this.className,
    required this.numberOfStudents,
    required this.image,
    required this.groupimg,
    required this.teachers,
    required this.students,
  });
}

class ClassData {
  static List<ClassList> classes = [
    ClassList(
      className: 'Class A',
      numberOfStudents: 20,
      image: 'assets/2.jpg',
      groupimg: 'assets/Group1.png',
      teachers: [
        // Generate teacher data for Class A
        TeacherList(
          className: 'Teacher 1',
          fullName: 'Teacher 1',
          image: 'assets/1.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
        TeacherList(
          className: 'Teacher 2',
          fullName: 'Teacher 2',
          image: 'assets/11.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
      ],
      students: [
        // Generate student data for Class A
        Students(
          className: 'Class A',
          fullname: 'Student 1',
          imagePath: 'assets/kim.png',
          dateOfBirth: '01-01-2005',
          Class: '',
          mobileNumber: '',
          percentage: 20,
        ),
        Students(
          className: 'Class A',
          fullname: 'Student 2',
          imagePath: 'assets/kim.png',
          dateOfBirth: '02-02-2005',
          Class: '',
          percentage: 20,
          mobileNumber: '',
        ),
      ],
    ),
    ClassList(
      className: 'Class B',
      numberOfStudents: 20,
      image: 'assets/3.jpg',
      groupimg: 'assets/Group1.png',
      teachers: [
        // Generate teacher data for Class A
        TeacherList(
          className: 'Teacher 1',
          fullName: 'Teacher 2',
          image: 'assets/9.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
        TeacherList(
          className: 'Teacher 2',
          fullName: 'Teacher 2',
          image: 'assets/8.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
      ],
      students: [
        // Generate student data for Class B
        Students(
          className: 'Class B',
          fullname: 'Student 1',
          imagePath: 'assets/john.png',
          dateOfBirth: '01-01-2005',
          Class: '',
          mobileNumber: '',
          percentage: 20,
        ),
        Students(
          className: 'Class A',
          fullname: 'Student 2',
          imagePath: 'assets/kim.png',
          dateOfBirth: '02-02-2005',
          Class: '',
          percentage: 20,
          mobileNumber: '',
        ),
      ],
    ),
    ClassList(
      className: 'Class C',
      numberOfStudents: 20,
      image: 'assets/4.jpg',
      groupimg: 'assets/Group1.png',
      teachers: [
        // Generate teacher data for Class A
        TeacherList(
          className: 'Teacher 1',
          fullName: 'Teacher 1',
          image: 'assets/10.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
        TeacherList(
          className: 'Teacher 2',
          fullName: 'Teacher 2',
          image: 'assets/10.jpg',
          phoneNumber: '1234567890',
          groupimg: '',
          Class: '',
          numberOfStudents: 20,
        ),
      ],
      students: [
        // Generate student data for Class A
        Students(
          className: 'Class C',
          fullname: 'Student 1',
          imagePath: 'assets/john.png',
          dateOfBirth: '01-01-2005',
          Class: '',
          mobileNumber: '',
          percentage: 20,
        ),
        Students(
          className: 'Class C',
          fullname: 'Student 2',
          imagePath: 'assets/john.png',
          dateOfBirth: '02-02-2005',
          Class: '',
          percentage: 20,
          mobileNumber: '',
        ),
      ],
    ),
  ];
}
