import 'package:flutter/material.dart';

class ProfilTech extends StatelessWidget {
  const ProfilTech({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Profile teacher'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  "assets/Ellipse22.png",
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ahmed ali',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              buildProfileField(context, 'First Name', 'John'),
              const SizedBox(height: 20),
              buildProfileField(context, 'Last Name', 'Doe'),
              const SizedBox(height: 20),
              buildProfileField(context, 'Location', 'Algiers'),
              const SizedBox(height: 20),
              buildProfileField(context, 'Mobile Number', '+21377705664'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: value,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
