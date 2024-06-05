import 'package:flutter/material.dart';
import 'package:assil_app/teacher/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEtudiant extends StatefulWidget {
  final Student student;

  const ProfileEtudiant({Key? key, required this.student}) : super(key: key);

  @override
  _ProfileEtudiantState createState() => _ProfileEtudiantState();
}

class _ProfileEtudiantState extends State<ProfileEtudiant> {
  late TextEditingController _fullNameController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _schoolYearController;
  late TextEditingController _parentPhoneNumberController;
  late TextEditingController _classIdController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.student.fullName);
    _dateOfBirthController = TextEditingController(text: widget.student.dateOfBirth);
    _schoolYearController = TextEditingController(text: widget.student.schoolYear);
    _parentPhoneNumberController = TextEditingController(text: widget.student.parentPhoneNumber);
    _classIdController = TextEditingController(text: widget.student.classId.toString());
  }

  Future<void> _updateStudent() async {
    final response = await http.put(
      Uri.parse('http://192.168.170.164:8000/students/${widget.student.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'full_name': _fullNameController.text,
        'date_of_birth': _dateOfBirthController.text,
        'school_year': _schoolYearController.text,
        'parent_phone_number': _parentPhoneNumberController.text,
        'class_id': int.parse(_classIdController.text),
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated the student
      final updatedStudent = Student.fromJson(json.decode(response.body));
      setState(() {
        // Update the student object with the new values
        widget.student.fullName = updatedStudent.fullName;
        widget.student.dateOfBirth = updatedStudent.dateOfBirth;
        widget.student.schoolYear = updatedStudent.schoolYear;
        widget.student.parentPhoneNumber = updatedStudent.parentPhoneNumber;
        widget.student.classId = updatedStudent.classId;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student updated successfully')),
      );
    } else {
      // Failed to update the student
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update student')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile student'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 232, 232, 232),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.student.profilePicture != null
                          ? NetworkImage(widget.student.profilePicture)
                          : AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildEditableProfileRow('Full Name', _fullNameController),
                Row(
                  children: [
                    Expanded(
                      child: buildEditableProfileField('Date of Birth', _dateOfBirthController),
                    ),
                    Expanded(
                      child: buildEditableProfileField('Current Year', _schoolYearController),
                    ),
                  ],
                ),
                buildEditableProfileRow('Parent Phone Number', _parentPhoneNumberController),
                const SizedBox(height: 10),
                Text(
                  'Class ID',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  controller: _classIdController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextButton(
                      onPressed: _updateStudent,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Save Changes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableProfileRow(String label, TextEditingController controller) {
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

  Widget buildEditableProfileField(String label, TextEditingController controller) {
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
