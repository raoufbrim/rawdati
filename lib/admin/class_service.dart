import 'dart:convert';
import 'package:http/http.dart' as http;
import 'class.dart';

class ClassService {
  static const String apiUrl = 'http://192.168.115.164:8000/classes/';

  static Future<List<Class>> fetchAllClasses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Class $jsonResponse');
      return jsonResponse.map((data) => Class.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  static Future<Class> fetchClassDetails(String className) async {
    final response = await http.get(Uri.parse('${apiUrl}name/$className'));

    if (response.statusCode == 200) {
      return Class.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load class details');
    }
  }
}
