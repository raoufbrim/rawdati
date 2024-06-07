import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilTech extends StatefulWidget {
  final String userEmail;

  const ProfilTech({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfilTechState createState() => _ProfilTechState();
}

class _ProfilTechState extends State<ProfilTech> {
  late Future<User> user;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _userNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  bool _isLoading = false;
  int? _userId; // Add a variable to store the user ID

  @override
  void initState() {
    super.initState();
    user = fetchUserProfile(widget.userEmail);
  }

  Future<User> fetchUserProfile(String email) async {
    final response = await http.get(Uri.parse('http://192.168.1.44:8000/user/profile?email=$email'));

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      _firstNameController = TextEditingController(text: user.first_name);
      _lastNameController = TextEditingController(text: user.last_name);
      _userNameController = TextEditingController(text: user.user_name ?? 'N/A');
      _emailController = TextEditingController(text: user.email);
      _phoneNumberController = TextEditingController(text: user.phone_number);
      _userId = user.id; // Store the user ID
      return user;
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> _updateUser(int? userId) async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is null')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.put(
      Uri.parse('http://192.168.1.44:8000/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': _firstNameController?.text,
        'last_name': _lastNameController?.text,
        'user_name': _userNameController?.text,
        'email': _emailController?.text,
        'phone_number': _phoneNumberController?.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update teacher')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Profile teacher'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<User>(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: snapshot.data!.profile_picture != null
                          ? NetworkImage(snapshot.data!.profile_picture!)
                          : AssetImage("assets/tech.jpg") as ImageProvider,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'teacher',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    buildEditableProfileRow('First Name', _firstNameController),
                    const SizedBox(height: 20),
                    buildEditableProfileRow('Last Name', _lastNameController),
                    const SizedBox(height: 20),
                    buildEditableProfileRow('User Name', _userNameController),
                    const SizedBox(height: 20),
                    buildEditableProfileRow('Email', _emailController),
                    const SizedBox(height: 20),
                    buildEditableProfileRow('Phone Number', _phoneNumberController),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _updateUser(_userId);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Save Changes'),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                return Text('No user data');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildEditableProfileRow(String label, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
    );
  }
}

class User {
  final int id; // Make this non-nullable
  final String first_name;
  final String last_name;
  final String? user_name;
  final String email;
  final String phone_number;
  final String? profile_picture;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    this.user_name,
    required this.email,
    required this.phone_number,
    this.profile_picture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Ensure id is non-nullable
      first_name: json['first_name'],
      last_name: json['last_name'],
      user_name: json['user_name'] ?? 'N/A',
      email: json['email'],
      phone_number: json['phone_number'],
      profile_picture: json['profile_picture'],
    );
  }
}
