class Students {
  final String fullname;
  final String imagePath;
  final String Class;
  final int percentage; // Progress percentage
  final String dateOfBirth;
  final String mobileNumber;

  Students({
    required this.fullname,
    required this.imagePath,
    required this.Class,
    required this.percentage,
    required this.dateOfBirth,
    required this.mobileNumber,
    required String className,
  });
}

List<Students> students = [
  Students(
    fullname: 'John Doe',
    imagePath: 'assets/john.png',
    Class: 'class A',
    percentage: 10,
    dateOfBirth: '01/01/2000',
    mobileNumber: '1234567890',
    className: '',
  ),
  Students(
    fullname: 'Anna Smith',
    imagePath: 'assets/anna.png',
    Class: 'class A',
    percentage: 60,
    dateOfBirth: '02/02/2001',
    mobileNumber: '0987654321',
    className: '',
  ),
  Students(
    fullname: 'Alice Johnson',
    imagePath: 'assets/alice.png',
    Class: 'class B',
    percentage: 20,
    dateOfBirth: '03/03/2002',
    mobileNumber: '4561237890',
    className: '',
  ),
  Students(
    fullname: 'Kim Nakamoto',
    imagePath: 'assets/kim.png',
    Class: 'class J',
    percentage: 10,
    dateOfBirth: '04/04/2003',
    mobileNumber: '7890123456',
    className: '',
  ),
  Students(
    fullname: 'ramdane Chennib',
    imagePath: 'assets/kim.png',
    Class: 'class H',
    percentage: 50,
    dateOfBirth: '04/04/2003',
    mobileNumber: '7890123456',
    className: '',
  ),
  Students(
    fullname: 'John Doe',
    imagePath: 'assets/john.png',
    Class: 'class B',
    percentage: 10,
    dateOfBirth: '01/01/2000',
    mobileNumber: '1234567890',
    className: '',
  ),
];
