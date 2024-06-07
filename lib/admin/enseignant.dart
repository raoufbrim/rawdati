class Teacher {
  int id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String profilePicture;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}
