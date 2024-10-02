import 'dart:convert'; // สำหรับใช้ jsonDecode
import 'dart:developer';
import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/model/Response/getUsers_res.dart';
import 'package:delivery_1_app/pages/sender/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class senderHomaPage extends StatefulWidget {
  const senderHomaPage({super.key});

  @override
  State<senderHomaPage> createState() => _senderHomaPageState();
}

class _senderHomaPageState extends State<senderHomaPage> {
  TextEditingController phoneNoCtl = TextEditingController();
  List<GetUsersRes> users = []; // Using GetUsersRes model
  String _userNoResultMessage = '';
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sender',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
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
                        onChanged: (value) {
                          if (value.length <= 10) {
                            _searchUsers(phoneNoCtl.text);
                          }
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Search by Phone Number or Name',
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
                          _searchUsers(phoneNoCtl.text);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sent to',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: users.isNotEmpty
                      ? ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user.image.isNotEmpty
                                      ? NetworkImage(user.image)
                                      : const AssetImage(
                                              'assets/images/default.jpg')
                                          as ImageProvider,
                                ),
                                title: Text('Name: ${user.name}'),
                                subtitle: Text('Phone: ${user.phone}'),
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
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const prodactPage()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(users.isEmpty
                              ? _userNoResultMessage
                              : 'No users found')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getMember() async {
    try {
      final res = await http.get(
        Uri.parse("$API_ENDPOINT/user/Getmember"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);

        List<GetUsersRes> allUsers = data.map((item) {
          return GetUsersRes.fromJson(item);
        }).toList();

        setState(() {
          users = allUsers;
          _userNoResultMessage = allUsers.isEmpty ? "ไม่มีผู้ใช้ที่จะแสดง" : '';
        });
      } else {
        print('Error fetching users: ${res.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _searchUsers(String phone) async {
    if (phone.isEmpty) {
      getMember();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$API_ENDPOINT/sender/search?phone=$phone'),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
      );

      if (response.statusCode == 200) {
        log("JSON ที่ได้รับ: ${response.body}");

        final List<dynamic> result = jsonDecode(response.body);
        List<GetUsersRes> foundUsers = result.map((item) {
          return GetUsersRes.fromJson(item);
        }).toList();

        // Log found users
        log("Found Users: ${foundUsers.map((user) => user.name).toList()}");

        setState(() {
          users = foundUsers;
          _userNoResultMessage =
              foundUsers.isEmpty ? "ไม่พบผู้ใช้ที่ค้นหา" : '';
          log("Updated Users: ${users.map((user) => user.name).toList()}"); // Log updated users
        });
      } else {
        log("เกิดข้อผิดพลาดในการเชื่อมต่อกับ API: ${response.statusCode}");
      }
    } catch (e) {
      log("เกิดข้อผิดพลาด: $e");
    }
  }
}
