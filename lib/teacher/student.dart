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
      id: json['id'],
      fullName: json['full_name'],
      dateOfBirth: json['date_of_birth'],
      schoolYear: json['school_year'],
      parentPhoneNumber: json['parent_phone_number'],
      profilePicture: json['profile_picture'],
      classId: json['class_id'],
    );
  }
}
