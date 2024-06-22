import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddClass.dart';
import 'package:assil_app/admin/class_service.dart';
import 'package:assil_app/admin/class.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AllClass extends StatefulWidget {
  const AllClass({Key? key}) : super(key: key);

  @override
  _AllClassState createState() => _AllClassState();
}

class _AllClassState extends State<AllClass> {
  late Future<List<Class>> _classesList;
  List<String> classImages = [];

  @override
  void initState() {
    super.initState();
    _classesList = ClassService.fetchAllClasses();
    loadClassImages();
  }

  void deleteClass(int index, int classId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.115.164:8000/classes/$classId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _classesList.then((classes) => classes.removeAt(index));
      });
    } else {
      // Affichez un message d'erreur si la suppression échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete class')),
      );
    }
  }

  Future<void> loadClassImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/classes/'))
        .toList();
    setState(() {
      classImages = imagePaths;
    });
  }

  String getRandomClassImage() {
    final random = Random();
    if (classImages.isNotEmpty) {
      final randomIndex = random.nextInt(classImages.length);
      return classImages[randomIndex];
    } else {
      return 'assets/default_image.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: FutureBuilder<List<Class>>(
        future: _classesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No classes found.'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for class',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'All classes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final classData = snapshot.data![index];
                      final imageUrl = getRandomClassImage();
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClassItem(
                          className: classData.name,
                          numberOfStudents: classData.students.length,
                          image: imageUrl,
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text("Are you sure you want to delete this class?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteClass(index, classData.id); // Supprimer la classe
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                          onPressed: () {
                            // Add navigation logic if needed
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF40B7D5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClass()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class ClassItem extends StatelessWidget {
  final String className;
  final int numberOfStudents;
  final String image;
  final VoidCallback onDelete;
  final VoidCallback onPressed;

  const ClassItem({
    required this.className,
    required this.numberOfStudents,
    required this.image,
    required this.onDelete,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF40B7D5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$numberOfStudents Students',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onPressed,
              child: Icon(
                Icons.chevron_right,
                color: Colors.green,
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
