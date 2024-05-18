import 'package:assil_app/admin/profiletech.dart';
import 'package:assil_app/teacher/Form.dart';
import 'package:assil_app/teacher/teacher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavBarRootsProf extends StatefulWidget {
  const NavBarRootsProf({super.key});

  @override
  State<NavBarRootsProf> createState() => _NavBarRootsProfState();
}

class _NavBarRootsProfState extends State<NavBarRootsProf> {
  @override
  int _selectedIndex = 0;
  int index = 0;

  final _screens = [
    HomeTeacher(),
    form(),
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
            Icons.bubble_chart, // Change icon to account_balance icon
            color: const Color(0xFF40B7D5), // Change color to #40B7D5
          ),
          Icon(
            Icons.person,
            color: const Color(0xFF40B7D5), // Change color to #40B7D5
          ),
        ],
      ),
    );
  }
}
