import 'dart:convert';
import 'package:http/http.dart' as http;
import 'enseignant.dart';

class TeacherService {
  static const String apiUrl = 'http://192.168.1.44:8000/teachers/';

  static Future<List<Teacher>> fetchAllTeachers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Teacher.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }
}
