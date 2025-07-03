import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grafos_aed/pages/costes.dart';
import 'package:grafos_aed/pages/grafos.dart';

void main() {
  runApp(
    const MaterialApp(home: Navigation(), debugShowCheckedModeBanner: false),
  );
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndexTab = 0;

  List<Widget> pages = [
    const Costes(), // Problema 1
    const Grafos(), // Problema 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndexTab],
      bottomNavigationBar: GNav(
        tabs: [
          GButton(
            icon: Icons.money_sharp,
            text: 'Costes',
            iconColor: Colors.blue,
            textStyle: const TextStyle(color: Colors.blue),
          ),
          GButton(
            icon: Icons.graphic_eq,
            text: 'Grafos - Millas',
            iconColor: Colors.blue,
            textStyle: const TextStyle(color: Colors.blue),
          ),
        ],
        selectedIndex: currentIndexTab,
        onTabChange: (index) {
          setState(() {
            currentIndexTab = index;
          });
        },
        style: GnavStyle.oldSchool,
        tabMargin: EdgeInsetsGeometry.zero,
        color: Colors.blue,
      ),
    );
  }
}
