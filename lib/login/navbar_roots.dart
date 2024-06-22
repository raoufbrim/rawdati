import 'package:assil_app/admin/AddStudent.dart';
import 'package:assil_app/admin/allclass.dart';
import 'package:assil_app/admin/home.dart';
import 'package:assil_app/admin/profiletech.dart';
import 'package:assil_app/admin/studentsick.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  final String userEmail;

  const NavBarRoots({super.key, required this.userEmail});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userEmail: widget.userEmail), // Passer l'adresse e-mail ici
      AllClass(),
      StudentSick(),
      AddStudent(),
      ProfilTech(userEmail: widget.userEmail), // Passer l'adresse e-mail ici
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blue.shade200,
          color: Colors.white,
          animationDuration: Duration(milliseconds: 200),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home,
              color: const Color(0xFF40B7D5),
            ),
            Icon(
              Icons.school,
              color: const Color(0xFF40B7D5),
            ),
            Icon(
            Icons.sick,
            color: const Color(0xFF40B7D5), // Change color to #40B7D5
          ),
            Icon(
              Icons.perm_contact_calendar_sharp,
              color: const Color(0xFF40B7D5),
            ),
            Icon(
              Icons.person,
              color: const Color(0xFF40B7D5),
            ),
          ]),
    );
  }
}
