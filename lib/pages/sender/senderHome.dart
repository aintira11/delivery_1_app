import 'dart:convert'; // สำหรับใช้ jsonDecode
import 'dart:developer';
import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/home_user.dart';
import 'package:delivery_1_app/pages/model/Response/getUsers_res.dart';
import 'package:delivery_1_app/pages/sender/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeUserPage()),
            );
          },
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
                            _searchUsers(
                                value); // เรียกใช้ฟังก์ชันค้นหาตามข้อความที่ป้อน
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
                                                prodactPage(id: user.id)),
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

  // Future<void> getMember() async {
  //   try {
  //     final res = await http.get(
  //       Uri.parse("$API_ENDPOINT/user/Getmember"),
  //       headers: {"Content-Type": "application/json; charset=utf-8"},
  //     );

  //     if (res.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(res.body);

  //       List<GetUsersRes> allUsers = data.map((item) {
  //         return GetUsersRes.fromJson(item);
  //       }).toList();

  //       setState(() {
  //         users = allUsers;
  //         _userNoResultMessage = allUsers.isEmpty ? "ไม่มีผู้ใช้ที่จะแสดง" : '';
  //       });
  //     } else {
  //       print('Error fetching users: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
  Future<void> getMember() async {
    try {
      // เข้าถึง collection "Users" และกรองด้วย type เป็น "user"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('type', isEqualTo: 'user')
          .get();

      // แปลงข้อมูลจากเอกสารใน QuerySnapshot เป็น List<GetUsersRes>
      List<GetUsersRes> allUsers = getUsersResFromQuerySnapshot(querySnapshot);

      setState(() {
        users = allUsers; // กำหนด users ให้เป็น List<GetUsersRes>
        log('data : $allUsers');
        _userNoResultMessage = allUsers.isEmpty ? "ไม่มีผู้ใช้ที่จะแสดง" : '';
      });
    } catch (e) {
      log('Error fetching users: $e');
      print('Error: $e');
    }
  }

  void _searchUsers(String query) async {
    // หากไม่มี query ให้ดึงข้อมูลผู้ใช้ทั้งหมด
    if (query.isEmpty) {
      getMember(); // เรียกฟังก์ชันดึงข้อมูลผู้ใช้ทั้งหมด
      return;
    }

    try {
      // ดึงข้อมูลผู้ใช้ทั้งหมดจาก Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // กรองข้อมูลเบอร์โทรที่มีตัวเลขตาม query ที่ใส่
      List<GetUsersRes> foundUsers = querySnapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // ตรวจสอบว่ามีฟิลด์ 'phone' และไม่เป็น null
            if (data.containsKey('phone') && data['phone'] is String) {
              String phone = data['phone'];

              // ค้นหา phone ว่ามีเลขที่ระบุใน query หรือไม่
              if (phone.contains(query)) {
                return GetUsersRes.fromJson(data, doc.id);
              }
            }
            return null; // คืนค่า null ถ้าไม่ตรงเงื่อนไข
          })
          .where((user) => user != null) // กรองค่าที่เป็น null
          .cast<GetUsersRes>()
          .toList();

      setState(() {
        users = foundUsers; // อัปเดตรายการผู้ใช้ที่ค้นพบ
        _userNoResultMessage = foundUsers.isEmpty ? "ไม่พบผู้ใช้ที่ค้นหา" : '';
      });

      log("Found Users: ${foundUsers.map((user) => user.name).toList()}");
    } catch (e) {
      log("เกิดข้อผิดพลาด: $e");
    }
  }
}
