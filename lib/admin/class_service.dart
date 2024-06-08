import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assil_app/admin/class.dart';

class ClassService {
  static const String apiUrl = 'http://192.168.1.44:8000/classes/';

  static Future<List<Class>> fetchAllClasses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Class.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }
}
