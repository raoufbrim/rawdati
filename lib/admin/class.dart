import 'package:assil_app/teacher/student.dart';
import 'package:assil_app/admin/enseignant.dart';

class Class {
  int id;
  String name;
  Teacher teacher;
  List<Student> students;

  Class({
    required this.id,
    required this.name,
    required this.teacher,
    required this.students,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    var teacherJson = json['teacher'] as Map<String, dynamic>? ?? {};
    var studentsJson = json['students'] as List<dynamic>? ?? [];

    List<Student> studentsList = studentsJson.map((i) => Student.fromJson(i)).toList();

    return Class(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      teacher: Teacher.fromJson(teacherJson),
      students: studentsList,
    );
  }
}
