import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/login.dart';
import 'package:delivery_1_app/pages/sender/Maindrawer.dart';
import 'package:delivery_1_app/pages/receiver/receiverHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  late UserProfile user;
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 183, 64),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // เคลียร์ข้อมูลผู้ใช้
              Provider.of<AppData>(context, listen: false).clearUser();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // เปลี่ยนเป็นหน้า Login ของคุณ
              );
            },
          ),
        ],
      ),
      body: Consumer<AppData>(builder: (context, appData, child) {
        UserProfile user =
            appData.user; // เข้าถึง UserProfile ที่เก็บไว้ใน AppData
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Profile Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          user.image), // ใช้ NetworkImage เพื่อโหลดภาพจาก URL
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ${user.name}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Phone : ${user.phone}'),
                        Text('Address : ${user.address}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.black),
                const SizedBox(height: 20),
                // Sender and Receiver buttons
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // จัดให้อยู่กลางจอแนวตั้ง
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // จัดให้อยู่กลางจอแนวนอน
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainDrawerPage()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF702D),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // เพิ่ม padding เพื่อย่อรูปภาพ
                                  child: Image.asset(
                                    'assets/images/delivery (1).png',
                                    fit: BoxFit
                                        .contain, // ปรับให้รูปภาพถูกย่อให้พอดีกับ Container
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sender',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const receiverHomePage()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 190, 130),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // เพิ่ม padding เพื่อย่อรูปภาพ
                                  child: Image.asset(
                                    'assets/images/receiving.png',
                                    fit: BoxFit
                                        .contain, // ปรับให้รูปภาพถูกย่อให้พอดีกับ Container
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Receiver',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
