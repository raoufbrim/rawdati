import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String role = 'teacher'; // Default role
  final Authentication _auth = Authentication();

  void handleSignUp() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = phoneNumberController.text;

    Map<String, dynamic> result = await _auth.signup(
        firstName, lastName, username, email, password, phoneNumber, role);

    if (result.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            const Text(
              "Create your account",
              style: TextStyle(fontSize: 18, color: Colors.grey), // Grey color
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
             ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/log2.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Form(
              child: Column(
                children: [
                  buildTextFormField(
                      Icons.person,
                      "First Name",
                      firstNameController,
                      TextInputType.name,
                      (value) => value == null || value.isEmpty
                          ? 'Please enter your first name'
                          : null),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildTextFormField(
                      Icons.person,
                      "Last Name",
                      lastNameController,
                      TextInputType.name,
                      (value) => value == null || value.isEmpty
                          ? 'Please enter your last name'
                          : null),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildTextFormField(
                      Icons.person,
                      "Username",
                      usernameController,
                      TextInputType.name,
                      (value) => value == null || value.isEmpty
                          ? 'Please enter your username'
                          : null),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildTextFormField(
                      Icons.email,
                      "Email",
                      emailController,
                      TextInputType.emailAddress,
                      (value) => !(value?.contains('@') ?? false)
                          ? 'Please enter a valid email'
                          : null),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildTextFormField(
                      Icons.lock,
                      "Password",
                      passwordController,
                      TextInputType.visiblePassword,
                      (value) => value == null || value.isEmpty
                          ? 'Please enter your password'
                          : null,
                      true),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildTextFormField(
                      Icons.phone,
                      "Phone Number",
                      phoneNumberController,
                      TextInputType.phone,
                      (value) => value == null || value.isEmpty
                          ? 'Please enter your phone number'
                          : null),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  buildRoleDropdown(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  buildSignUpButton(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  buildSignInRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(
      IconData icon,
      String hintText,
      TextEditingController controller,
      TextInputType keyboardType,
      String? Function(String?)? validator,
      [bool obscureText = false,
      void Function()? onTap]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
        ),
      ),
    );
  }

  Widget buildRoleDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10.0),
        child: DropdownButtonFormField<String>(
          value: role,
          decoration: InputDecoration(
            hintText: "Select Role",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          items: <String>['teacher', 'admin']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              role = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF40B7D5), // Change color to #40B7D5
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(Icons.navigate_next_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignInRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ",
            style: TextStyle(fontSize: 14, color: Colors.grey)), // Grey color
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn())),
          child: Text(
            "Sign In",
            style: TextStyle(
              decorationThickness: 2.0,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF40B7D5), // Change color to #40B7D5
            ),
          ),
        ),
      ],
    );
  }
}
