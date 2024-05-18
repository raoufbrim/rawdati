class Student {
  final String name;
  final String familyName;
  final String imagePath;
  final String currentYear;
  final int percentage; // Progress percentage
  final String dateOfBirth;
  final String mobileNumber;

  Student({
    required this.name,
    required this.familyName,
    required this.imagePath,
    required this.currentYear,
    required this.percentage,
    required this.dateOfBirth,
    required this.mobileNumber,
  });
}

List<Student> students = [
  Student(
    name: 'John',
    familyName: 'Doe',
    imagePath: 'assets/john.png',
    currentYear: '3AP',
    percentage: 10,
    dateOfBirth: '01/01/2000',
    mobileNumber: '1234567890',
  ),
  Student(
    name: 'Anna',
    familyName: 'Smith',
    imagePath: 'assets/anna.png',
    currentYear: '2AP',
    percentage: 60,
    dateOfBirth: '02/02/2001',
    mobileNumber: '0987654321',
  ),
  Student(
    name: 'Alice',
    familyName: 'Johnson',
    imagePath: 'assets/alice.png',
    currentYear: '1AP',
    percentage: 20,
    dateOfBirth: '03/03/2002',
    mobileNumber: '4561237890',
  ),
  Student(
    name: 'Kim',
    familyName: 'Nakamoto',
    imagePath: 'assets/kim.png',
    currentYear: '4AP',
    percentage: 10,
    dateOfBirth: '04/04/2003',
    mobileNumber: '7890123456',
  ),
  Student(
    name: 'ramdane',
    familyName: 'chennibe',
    imagePath: 'assets/kim.png',
    currentYear: '4AP',
    percentage: 50,
    dateOfBirth: '04/04/2003',
    mobileNumber: '7890123456',
  ),
];
