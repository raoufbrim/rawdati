import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assil_app/admin/DetaillClass.dart';
import 'package:assil_app/admin/allclass.dart';
import 'package:assil_app/admin/allstudents.dart';
import 'package:assil_app/admin/allteachers.dart';
import 'package:assil_app/admin/profileetudient.dart';
import 'package:assil_app/teacher/student_service.dart';
import 'package:assil_app/teacher/student.dart' as studentModel;
import 'package:assil_app/admin/profiletech.dart';
import 'package:assil_app/admin/teacher_service.dart';
import 'package:assil_app/admin/enseignant.dart' as teacherModel;
import 'package:assil_app/admin/class_service.dart';
import 'package:assil_app/admin/class.dart' as classModel;

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotificationService _notificationService;
  int _notificationCount = 0;
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService('ws://192.168.115.164:8000/ws/notifications');
    _notificationService.notifications.listen((notification) {
      setState(() {
        _notificationCount++;
        _notifications.add(notification);
      });
    });
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  void _showNotifications() {
    setState(() {
      _notificationCount = 0;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _notifications.map((notification) => ListTile(title: Text(notification))).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getImages(String path) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains(path))
        .toList();
    return imagePaths;
  }

  Future<String> _getRandomImage(String path) async {
    final imagePaths = await _getImages(path);
    final randomIndex = Random().nextInt(imagePaths.length);
    return imagePaths[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: _showNotifications,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlueSpace(),
            FutureBuilder<List<classModel.Class>>(
              future: ClassService.fetchAllClasses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No classes found.'));
                } else {
                  return _buildHorizontalListView(
                    "Class Category",
                    snapshot.data!.length,
                    (BuildContext context, int index) => ClassCategory(
                      classData: snapshot.data![index],
                      getRandomImage: () => _getRandomImage('assets/classes/'),
                    ),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllClass()),
                      );
                    },
                    snapshot,
                  );
                }
              },
            ),
            FutureBuilder<List<teacherModel.Teacher>>(
              future: TeacherService.fetchAllTeachers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No teachers found.'));
                } else {
                  return _buildHorizontalListView(
                    "Teachers",
                    snapshot.data!.length,
                    (BuildContext context, int index) => TeacherCard(
                      teacher: snapshot.data![index],
                      getRandomImage: () => _getRandomImage('assets/enseignant/'),
                    ),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllTeachers()),
                      );
                    },
                    snapshot,
                  );
                }
              },
            ),
            FutureBuilder<List<studentModel.Student>>(
              future: StudentService.fetchAllStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No students found.'));
                } else {
                  return _buildHorizontalListView(
                    "Students",
                    snapshot.data!.length,
                    (BuildContext context, int index) => StudentCard(
                      student: snapshot.data![index],
                      getRandomImage: () => _getRandomImage('assets/etudiant/'),
                    ),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllStudents()),
                      );
                    },
                    snapshot,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueSpace() {
    return Container(
      color: const Color(0xFF40B7D5),
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
    [AsyncSnapshot<dynamic>? snapshot]
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
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (snapshot != null && snapshot.hasData) {
                return InkWell(
                  onTap: () {
                    if (snapshot.data![index] is studentModel.Student) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEtudiant(student: snapshot.data![index]),
                        ),
                      );
                    } else if (snapshot.data![index] is teacherModel.Teacher) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilTech(userEmail: (snapshot.data![index] as teacherModel.Teacher).email),
                        ),
                      );
                    } else if (snapshot.data![index] is classModel.Class) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailsPage(className: (snapshot.data![index] as classModel.Class).name),
                        ),
                      );
                    }
                  },
                  child: itemBuilder(context, index),
                );
              } else {
                return itemBuilder(context, index);
              }
            },
          ),
        ),
      ],
    );
  }
}

class ClassCategory extends StatelessWidget {
  final classModel.Class classData;
  final Future<String> Function() getRandomImage;

  const ClassCategory({Key? key, required this.classData, required this.getRandomImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getRandomImage(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDetailsPage(className: classData.name),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 185,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 176, 217, 227),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          classData.teacher.profilePicture,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return snapshot.hasData
                                ? Image.asset(snapshot.data!)
                                : Image.asset('assets/default_image.png');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classData.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              Icon(Icons.group),
                              const SizedBox(width: 8),
                              Text(
                                '${classData.studentCounts} Student${classData.students.length != 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
      },
    );
  }
}

class TeacherCard extends StatelessWidget {
  final teacherModel.Teacher teacher;
  final Future<String> Function() getRandomImage;

  const TeacherCard({Key? key, required this.teacher, required this.getRandomImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullName = '${teacher.firstName} ${teacher.lastName}';

    return FutureBuilder<String>(
      future: getRandomImage(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilTech(userEmail: teacher.email),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 185,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 176, 217, 227),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: teacher.profilePicture.isNotEmpty
                            ? Image.network(
                                teacher.profilePicture,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return snapshot.hasData
                                      ? Image.asset(snapshot.data!)
                                      : Image.asset('assets/default_image.png');
                                },
                              )
                            : snapshot.hasData
                                ? Image.asset(snapshot.data!)
                                : Image.asset('assets/default_image.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isNotEmpty ? fullName : 'Unknown Teacher',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
      },
    );
  }
}

class StudentCard extends StatelessWidget {
  final studentModel.Student student;
  final Future<String> Function() getRandomImage;

  const StudentCard({Key? key, required this.student, required this.getRandomImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getRandomImage(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEtudiant(student: student),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 185,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 176, 217, 227),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: student.profilePicture.isNotEmpty
                            ? Image.network(
                                student.profilePicture,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return snapshot.hasData
                                      ? Image.asset(snapshot.data!)
                                      : Image.asset('assets/default_image.png');
                                },
                              )
                            : snapshot.hasData
                                ? Image.asset(snapshot.data!)
                                : Image.asset('assets/default_image.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.fullName ?? 'Unknown Student',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Year: ' + student.schoolYear,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
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
      },
    );
  }
}
