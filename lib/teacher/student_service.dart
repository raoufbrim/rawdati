import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';

class StudentService {
  static const String apiUrl = 'http://192.168.1.44:8000'; // Replace with your actual backend URL

  // Function to fetch all students
  static Future<List<Student>> fetchAllStudents() async {
    final response = await http.get(Uri.parse('$apiUrl/students/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Student> students = body.map((dynamic item) => Student.fromJson(item)).toList();
      return students;
    } else {
      throw Exception('Failed to load students');
    }
  }

  // Existing function to fetch students by teacher email
  static Future<List<Student>> fetchStudentsByTeacherEmail(String teacherEmail) async {
  final response = await http.get(Uri.parse('$apiUrl/teachers/$teacherEmail/students'));

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Student> students = body.map((dynamic item) => Student.fromJson(item)).toList();
    return students;
  } else {
    throw Exception('Failed to load students');
  }
}

}
