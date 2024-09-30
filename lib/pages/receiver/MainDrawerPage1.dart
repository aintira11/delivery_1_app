import 'dart:developer';

import 'package:delivery_1_app/pages/home_user.dart';
import 'package:delivery_1_app/pages/receiver/toreceiver.dart';
import 'package:delivery_1_app/pages/receiver/toship.dart';
import 'package:flutter/material.dart';

class MainDrawer1Page extends StatefulWidget {
  final int value;
  const MainDrawer1Page({super.key, required this.value});

  @override
  State<MainDrawer1Page> createState() => _MainDrawer1PageState();
}

class _MainDrawer1PageState extends State<MainDrawer1Page> {
  late int value;
  Widget curretnPage = ToShipPage();

  @override
  void initState() {
    super.initState();
    // กำหนดค่า value จาก widget.value
    value = widget.value;
    switchPage(value); // เรียก switchPage เพื่อแสดงหน้าแรกตาม value
  }

  void switchPage(int index) {
    setState(() {
      value = index; // Update the current index
      log(index.toString());

      // Change the current page based on the selected tab
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeUserPage(),
          ),
        );
      } else if (index == 1) {
        // Replace with actual page when ready
        curretnPage = ToShipPage(); // Placeholder for Status page
      } else if (index == 2) {
        // Replace with actual page when ready
        curretnPage = toReceiverPage(); // Placeholder for Wait page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: curretnPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEF702D),
        currentIndex: value, // Reflect the current index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'To Ship',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall),
            label: 'To Receive',
          ),
        ],
        onTap: switchPage, // Call the function to switch pages on tap
        selectedItemColor: Colors.black, // Color for selected item
        unselectedItemColor: Colors.white, // Color for unselected items
      ),
    );
  }
}
