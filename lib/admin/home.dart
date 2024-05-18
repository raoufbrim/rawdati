import 'package:assil_app/admin/allclass.dart';
import 'package:assil_app/admin/allteachers.dart';
import 'package:flutter/material.dart';
import 'Class_List.dart'; // Assuming ClassList and ClassData are defined in this file
import 'Teacher_List.dart'; // Assuming TeacherList and TeacherData are defined in this file

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlueSpace(),
            _buildHorizontalListView(
              "Class Category",
              ClassData.classes.length,
              (BuildContext context, int index) => ClassCategory(index: index),
              () {
                // Navigate to AllClassPage when "See All" is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllClass()),
                );
              },
            ),
            _buildHorizontalListView(
              "Teachers",
              TeacherData.teachers.length,
              (BuildContext context, int index) =>
                  TeacherCategory(index: index),
              () {
                // Navigate to AllTechPage when "See All" is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => allteachers()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueSpace() {
    return Container(
      color: const Color(0xFF40B7D5), // Change color to #40B7D5
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            right: 10,
            child: Image.asset(
              "assets/hob.png",
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hi Admin",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Good morning",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListView(
    String title,
    int itemCount,
    Widget Function(BuildContext, int) itemBuilder,
    VoidCallback seeAllCallback,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: seeAllCallback,
                child: Text("See All"),
              ),
            ],
          ),
        ),
        Container(
          height: 260, // Adjust the height of the list view
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Handle item tap here
                },
                child: itemBuilder(context, index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ClassCategory extends StatelessWidget {
  final int index;

  const ClassCategory({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myClass = ClassData.classes[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8, // Add elevation
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllClass()),
            );
          },
          child: Container(
            width: 200, // Adjust the width of the item
            height: 300, // Adjust the height of the item
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white, // Background color of the whole item
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10), // Adjust vertical space
                Container(
                  width: 185, // Adjust image width
                  height: 150, // Adjust image height
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 176, 217, 227),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      myClass.image,
                      fit: BoxFit.cover, // Adjust image fit
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myClass.className,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Image.asset(
                        myClass.groupimg,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeacherCategory extends StatelessWidget {
  final int index;

  const TeacherCategory({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacher = TeacherData.teachers[index];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8, // Add elevation
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => allteachers()),
            );
          },
          child: Container(
            width: 200, // Adjust the width of the item
            height: 200, // Adjust the height of the item
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white, // Background color of the whole item
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10), // Adjust vertical space
                Container(
                  width: 185, // Adjust image width
                  height: 150, // Adjust image height
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 176, 217, 227),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      teacher.image,
                      fit: BoxFit.cover, // Adjust image fit
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.className,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Image.asset(
                        teacher.groupimg,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
