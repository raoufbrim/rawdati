class TeacherList {
  final String className;
  final int numberOfTeachers;
  final String image;
  final String groupimg;

  TeacherList({
    required this.className,
    required this.numberOfTeachers,
    required this.image,
    required this.groupimg,
  });
}

class TeacherData {
  static List<TeacherList> teachers = [
    TeacherList(
      className: 'teacher 1',
      numberOfTeachers: 20,
      image: 'assets/pana.png',
      groupimg: 'assets/Group.png',
    ),
    TeacherList(
      className: 'teacher 2',
      numberOfTeachers: 18,
      image: 'assets/cuate.png',
      groupimg: 'assets/Group.png',
    ),
    TeacherList(
      className: 'teacher 3',
      numberOfTeachers: 25,
      image: 'assets/cuatee.png',
      groupimg: 'assets/Group.png',
    ),

    // Add more teachers as needed
  ];
}
