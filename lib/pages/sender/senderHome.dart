import 'package:delivery_1_app/pages/sender/product.dart';
import 'package:flutter/material.dart';

class senderHomaPage extends StatefulWidget {
  const senderHomaPage({super.key});

  @override
  State<senderHomaPage> createState() => _senderHomaPageState();
}

class _senderHomaPageState extends State<senderHomaPage> {
  TextEditingController phoneNoCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sender',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneNoCtl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Search by Phone Number',
                      filled: true,
                      fillColor: Colors.orange[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      // Implement search functionality here
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'sent to',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // List of sent users
            Expanded(
              child: ListView(
                children: [
                  _buildUserCard(
                      'Yoko', '0111111111', 'assets/images/ดาวน์โหลด (11).jpg'),
                  _buildUserCard('Reeka', '0888888888',
                      'assets/images/ดาวน์โหลด (24).jpg'),
                  _buildUserCard('Shino', '0555555555',
                      'assets/images/47dd7da7-1746-4031-9033-666d36030775.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0, // Set the current index based on the selected tab
      //   onTap: (index) {
      //     // Handle bottom navigation tap
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_shipping),
      //       label: 'Status',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.hourglass_empty),
      //       label: 'Wait',
      //     ),
      //   ],
      //   selectedItemColor: Colors.orange[600],
      //   unselectedItemColor: Colors.black,
      // ),
    );
  }

  Widget _buildUserCard(String name, String phone, String avatar) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(avatar), // User avatar image
        ),
        title: Text('Name: $name'),
        subtitle: Text('Phone: $phone'),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const prodactPage()),
              );
            },
          ),
        ),
      ),
    );
  }
}
