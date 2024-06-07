import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static const String baseUrl = 'http://192.168.1.44:8000'; // URL de votre backend

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      return jsonDecode(response.body);
    } else {
      return {'error': 'Invalid email or password'};
    }
  }

  Future<Map<String, dynamic>> signup(String firstName, String lastName, String username, String email, String password, String phoneNumber, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'error': 'Registration failed'};
    }
  }
}
