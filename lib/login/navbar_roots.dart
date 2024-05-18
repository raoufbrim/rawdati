import 'package:assil_app/admin/AddStudent.dart';
import 'package:assil_app/admin/allclass.dart';
import 'package:assil_app/admin/home.dart';
import 'package:assil_app/admin/profiletech.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  @override
  int _selectedIndex = 0;
  int index = 0;

  final _screens = [
    HomeScreen(),
    AllClass(),
    AddStudent(),
    ProfilTech(),
  ];

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
              color: const Color(0xFF40B7D5), // Change color to #40B7D5
            ),
            Icon(
              Icons.school,
              color: const Color(0xFF40B7D5), // Change color to #40B7D5
            ),
            Icon(
              Icons.perm_contact_calendar_sharp,
              color: const Color(0xFF40B7D5), // Change color to #40B7D5
            ),
            Icon(
              Icons.person,
              color: const Color(0xFF40B7D5), // Change color to #40B7D5
            ),
          ]),
    );
  }
}
