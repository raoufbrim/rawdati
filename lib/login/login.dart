import 'package:assil_app/login/navbar_roots.dart';
import 'package:assil_app/login/navbar_rootsProf.dart';
import 'package:assil_app/login/signup.dart';
import 'package:assil_app/teacher/teacher.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'forget_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
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
              "Sign In",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            const Text(
              "Sign in to your account",
              style: TextStyle(fontSize: 18, color: Colors.grey), // Grey color
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Form(
              child: Column(
                children: [
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
                      null,
                      obscureText,
                      togglePasswordVisibility),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  buildForgotPasswordRow(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  buildSignInButton(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  buildSignUpRow(context),
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

  Widget buildForgotPasswordRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
          child: Text("Forget your password?",
              style: TextStyle(
                  color: const Color(0xFF40B7D5))), // Change color to #40B7D5
        ),
      ),
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: () async {
          String email = emailController.text;
          String password = passwordController.text;

          bool isAuthenticated =
              StaticAuthentication.authenticateTeacher(email, password);

          if (isAuthenticated) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NavBarRootsProf()));
          } else if (StaticAuthentication.authenticateAdmin(email, password)) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NavBarRoots()));
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Wrong email or password.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
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
                "Sign in",
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

  Widget buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ",
            style: TextStyle(fontSize: 14, color: Colors.grey)), // Grey color
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUp())),
          child: Text(
            "Sign Up",
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
