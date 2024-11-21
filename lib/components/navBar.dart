import 'package:flutter/material.dart';
import '../dashboard.dart'; // Import your Dashboard page
import '../profilePage.dart'; // Import your Profile page

class NavigationBarComponent extends StatefulWidget {
  final int currentIndex; // Pass the current index to highlight the correct tab

  NavigationBarComponent({required this.currentIndex});

  @override
  _NavigationBarComponentState createState() => _NavigationBarComponentState();
}

class _NavigationBarComponentState extends State<NavigationBarComponent> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex; // Set the initial selected index
  }

  // Navigation logic for each tab
  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else if (index == 1 && _selectedIndex != 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Restaurant',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      onTap: _onItemTapped,
    );
  }
}
