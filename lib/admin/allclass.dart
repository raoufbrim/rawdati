import 'package:flutter/material.dart';
import 'package:assil_app/admin/AddClass.dart';
import 'package:assil_app/admin/Class_List.dart';

class AllClass extends StatefulWidget {
  const AllClass({Key? key}) : super(key: key);

  @override
  _AllClassState createState() => _AllClassState();
}

class _AllClassState extends State<AllClass> {
  List<ClassList> classesList = ClassData.classes.toList();

  void deleteClass(int index) {
    setState(() {
      classesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: classesList.length,
              itemBuilder: (context, index) {
                final classData = classesList[index];
                return GestureDetector(
                  onLongPress: () {
                    // Show confirmation dialog before deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm Deletion"),
                        content:
                            Text("Are you sure you want to delete this class?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Delete the class from the list
                              deleteClass(index);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClassItem(
                      className: classData.className,
                      numberOfStudents: classData.numberOfStudents,
                      image: classData.image,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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

  const ClassItem({
    required this.className,
    required this.numberOfStudents,
    required this.image,
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
            // Container for class icon
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
            // Column for class details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for class name
                  Row(
                    children: [
                      Text(
                        className,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Row for number of students
                  Row(
                    children: [
                      Text(
                        '$numberOfStudents Students',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Icon for navigation
            Column(
              children: [
                Icon(Icons.chevron_right, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
