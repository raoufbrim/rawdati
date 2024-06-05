import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String? _fullName;
  DateTime? _dob;
  String? _schoolYear;
  String? _parentPhoneNumber;
  int? _classId;
  File? _selectedImage;
  final picker = ImagePicker();
  List<File> _imageList = [];
  final TextEditingController _dobController = TextEditingController();

  Future getImageGallery() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      setState(() {
        _imageList.add(File(pickerFile.path));
        _selectedImage = File(pickerFile.path);
      });
    } else {
      print('no image selected');
    }
  }

  Future getImageCamera() async {
    final pickerFile = await picker.pickImage(source: ImageSource.camera);
    if (pickerFile != null) {
      setState(() {
        _imageList.add(File(pickerFile.path));
        _selectedImage = File(pickerFile.path);
      });
    } else {
      print('no image selected');
    }
  }

  Future<void> _addStudent() async {
    if (_fullName == null || _dob == null || _schoolYear == null || _parentPhoneNumber == null || _classId == null || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields and select an image.'),
      ));
      return;
    }

    // Sauvegarder l'image localement
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
    final File localImage = await _selectedImage!.copy('$path/$fileName');

    final String fullName = _fullName!;
    final String dob = _dob!.toIso8601String();
    final String schoolYear = _schoolYear!;
    final String parentPhoneNumber = _parentPhoneNumber!;
    final String profilePicturePath = localImage.path; // Chemin de l'image locale
    final int classId = _classId!;

    final url = Uri.parse('http://192.168.170.164:8000/students/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'full_name': fullName,
        'date_of_birth': dob,
        'school_year': schoolYear,
        'parent_phone_number': parentPhoneNumber,
        'profile_picture': profilePicturePath, // Envoie le chemin de l'image
        'class_id': classId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Étudiant ajouté avec succès!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Échec de l\'ajout de l\'étudiant'),
      ));
    }
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          content: Container(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
        _dobController.text = _dob!.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Full Name',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _fullName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date of Birth',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: _dobController,
                          onTap: () => _selectDate(context),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Select your date of birth',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Year',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _schoolYear = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter your current year',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _parentPhoneNumber = value;
                  });
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Parent Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _classId = int.tryParse(value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Class ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Container(
                  height: 100,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 224, 224),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: const Color(0xFF40B7D5),
                          size: 50,
                        ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: _addStudent,
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
      ),
    );
  }
}
