import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String? _selectedTeacher;
  final TextEditingController _nameController = TextEditingController();
  Map<String, int> _teachers = {};

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    final response = await http.get(Uri.parse('http://192.168.170.164:8000/teachers/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _teachers = {for (var teacher in data) teacher['email']: teacher['id']};
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load teachers')),
      );
    }
  }

 Future<void> _submitForm() async {
  if (_nameController.text.isEmpty || _selectedTeacher == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez remplir tous les champs')),
    );
    return;
  }

  final int teacherId = _teachers[_selectedTeacher]!;

  final response = await http.post(
    Uri.parse('http://192.168.170.164:8000/classes/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': _nameController.text,
      'teacher_id': teacherId,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Classe ajoutée avec succès')),
    );
  } else if (response.statusCode == 400) {
    final Map<String, dynamic> errorResponse = jsonDecode(response.body);
    if (errorResponse['detail'] == 'Class name already exists') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Le nom de la classe existe déjà, veuillez en choisir un autre')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.body}')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${response.body}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une classe'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nom de la classe',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom de la classe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Professeur',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedTeacher,
              hint: Text('Choisissez un professeur'),
              items: _teachers.keys.map((String email) {
                return DropdownMenuItem<String>(
                  value: email,
                  child: Text(email),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeacher = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40B7D5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ajouter",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(Icons.navigate_next_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
