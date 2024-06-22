import 'package:assil_app/teacher/student.dart';
import 'package:assil_app/admin/enseignant.dart';

class Class {
  int id;
  String name;
  Teacher teacher;
  List<Student> students;
  num ? studentCounts;

  Class({
    required this.id,
    required this.name,
    required this.teacher,
    required this.students,
    this.studentCounts,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    print(json['student_count']);
    var teacherJson = json['teacher'] as Map<String, dynamic>? ?? {};
    var studentsJson = json['students'] as List<dynamic>? ?? [];

    List<Student> studentsList = studentsJson.map((i) => Student.fromJson(i)).toList();

    return Class(
      id: json['id'] ?? 0, // Default to 0 if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
      teacher: Teacher.fromJson(teacherJson),
      students: studentsList,
      studentCounts: json['student_count']
    );
  }
}

class Teacher {
  String first_name;
  String profilePicture;

  Teacher({
    required this.first_name,
    required this.profilePicture,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      first_name: json['first_name'] ?? 'Unknown', // Default to 'Unknown' if null
      profilePicture: json['profile_picture'] ?? '', // Default to empty string if null
    );
  }
}

class Student {
  String fullName;
  String dateOfBirth;
  String profilePicture;

  Student({
    required this.fullName,
    required this.dateOfBirth,
    required this.profilePicture,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      fullName: json['full_name'] ?? 'Unknown', // Default to 'Unknown' if null
      dateOfBirth: json['date_of_birth'] ?? '', // Default to empty string if null
      profilePicture: json['profile_picture'] ?? '', // Default to empty string if null
    );
  }
}
