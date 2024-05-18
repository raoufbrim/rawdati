class StaticAuthentication {
  // Hardcoded user data
  static const List<Map<String, String>> _teachers = [
    {'email': 'teacher1@gmail.com', 'password': 'teacher1'},
    {'email': 'teacher2@gmail.com', 'password': 'teacher2'},
    // Add more teachers as needed
  ];

  static const Map<String, String> _admins = {'admin': 'admin'};

  // Authentication method for teachers
  static bool authenticateTeacher(String email, String password) {
    return _teachers.any((teacher) =>
        teacher['email'] == email && teacher['password'] == password);
  }

  // Authentication method for admins
  static bool authenticateAdmin(String email, String password) {
    return _admins.containsKey(email) && _admins[email] == password;
  }
}
