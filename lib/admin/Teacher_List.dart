class TeacherList {
  final String className;
  final int numberOfStudents;
  final String image;
  final String groupimg;
  final String Class;

  TeacherList({
    required this.className,
    required this.numberOfStudents,
    required this.image,
    required this.groupimg,
    required this.Class,
    required String fullName,
    required String phoneNumber,
  });
}

class TeacherData {
  static List<TeacherList> teachers = [
    TeacherList(
      className: 'teacher 1',
      numberOfStudents: 20,
      image: 'assets/9.jpg',
      groupimg: 'assets/Group.png',
      Class: 'class A',
      fullName: '',
      phoneNumber: '',
    ),
    TeacherList(
      className: 'teacher 2',
      numberOfStudents: 18,
      image: 'assets/10.jpg',
      groupimg: 'assets/Group.png',
      Class: 'class A',
      fullName: '',
      phoneNumber: '',
    ),
    TeacherList(
      className: 'teacher 3',
      numberOfStudents: 25,
      image: 'assets/11.jpg',
      groupimg: 'assets/Group.png',
      Class: 'class A',
      fullName: '',
      phoneNumber: '',
    ),
    TeacherList(
      className: 'teacher 3',
      numberOfStudents: 25,
      image: 'assets/1.jpg',
      groupimg: 'assets/Group.png',
      Class: 'class A',
      fullName: '',
      phoneNumber: '',
    ),
    // Add more teachers as needed
  ];
}
