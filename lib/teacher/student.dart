class Student {
   int id;
   String fullName;
   String dateOfBirth;
   String schoolYear;
   String parentPhoneNumber;
   String profilePicture;
   int classId;

  Student({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.schoolYear,
    required this.parentPhoneNumber,
    required this.profilePicture,
    required this.classId,
  });

    factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Unknown',
      dateOfBirth: json['date_of_birth'] ?? 'Unknown',
      schoolYear: json['school_year'] ?? 'Unknown',
      parentPhoneNumber: json['parent_phone_number'] ?? 'Unknown',
      profilePicture: json['profile_picture'] ?? 'assets/default_avatar.png',
      classId: json['class_id'] ?? 0,
    );
  }
}