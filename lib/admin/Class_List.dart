class ClassList {
  final String className;
  final int numberOfStudents;
  final String image;
  final String groupimg;

  ClassList({
    required this.className,
    required this.numberOfStudents,
    required this.image,
    required this.groupimg,
  });
}

class ClassData {
  static List<ClassList> classes = [
    ClassList(
      className: 'Class A',
      numberOfStudents: 20,
      image: 'assets/image8.png',
      groupimg: 'assets/Group1.png',
    ),
    ClassList(
      className: 'Class B',
      numberOfStudents: 18,
      image: 'assets/image7.png',
      groupimg: 'assets/Group1.png',
    ),
    ClassList(
      className: 'Class C',
      numberOfStudents: 25,
      image: 'assets/img4.png',
      groupimg: 'assets/Group1.png',
    ),
    ClassList(
      className: 'Class D',
      numberOfStudents: 25,
      image: 'assets/image11.png',
      groupimg: 'assets/Group1.png',
    ),
    ClassList(
      className: 'Class E',
      numberOfStudents: 25,
      image: 'assets/imag12.png',
      groupimg: 'assets/Group1.png',
    ),
    ClassList(
      className: 'Class J',
      numberOfStudents: 25,
      image: 'assets/image13.png',
      groupimg: 'assets/Group1.png',
    ),
    // Add more classes as needed
  ];
}
