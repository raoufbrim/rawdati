import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  String? _selectedTeacher;
  File? _selectedImage;
  final picker = ImagePicker();
  List<File> _imageList = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  List<String> _classes = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5'
  ];
  String? _selectedClass;

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

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          content: Container(
            color: Colors.white,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teacher'),
      ),
      body: Container(
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Teacher Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Birth Date',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Birth Date',
                border: OutlineInputBorder(),
              ),
            ),
            Text(
              'Classes',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              items: _classes.map((String classItem) {
                return DropdownMenuItem<String>(
                  value: classItem,
                  child: Text(classItem),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
              },
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
                  color: const Color.fromARGB(255, 237, 234, 234),
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
                        color:
                            const Color(0xFF40B7D5), // Change color to #40B7D5
                        size: 50,
                      ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  // Add button functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF40B7D5), // Change color to #40B7D5
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
                        "Add",
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
