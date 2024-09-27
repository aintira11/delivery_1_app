import 'dart:developer';
import 'package:delivery_1_app/pages/sender/senderHome.dart';
import 'package:flutter/material.dart';


class MainDrawerPage extends StatefulWidget {
  const MainDrawerPage({super.key});

  @override
  State<MainDrawerPage> createState() => _MainDrawerPageState();
}

class _MainDrawerPageState extends State<MainDrawerPage> {
  int value = 0 ;
  //Widget curretnPage = Container();
  Widget curretnPage = senderHomaPage();
  // Function to switch between pages based on index
  void switchPage(int index) {
    setState(() {
      value = index; // Update the current index
      log(index.toString());

      // Change the current page based on the selected tab
      if (index == 0) {
        curretnPage = senderHomaPage();
      } else if (index == 1) {
        // Replace with actual page when ready
        curretnPage = Container(color: Colors.blue); // Placeholder for Status page
      } else if (index == 2) {
        // Replace with actual page when ready
        curretnPage = Container(color: Colors.red); // Placeholder for Wait page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: curretnPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:  Color(0xFFEF702D), 
        currentIndex: value, // Reflect the current index
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Wait',
          ),
        ],
        onTap: switchPage, // Call the function to switch pages on tap
        selectedItemColor: Colors.black, // Color for selected item
        unselectedItemColor: Colors.white, // Color for unselected items
      ),
    );
  }
}
