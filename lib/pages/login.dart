import 'dart:convert';
import 'dart:developer';

import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/home_user.dart';
import 'package:delivery_1_app/pages/model/Response/login_res.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController NameNoCtl = TextEditingController();
  TextEditingController PasswordNoCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.rocket_launch,
                        size: 60,
                        color: Colors.black,
                      ),
                      Text(
                        'DELIVERY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '- ROCKET DELIVERY -',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 183, 64),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Name'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: NameNoCtl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(0, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('Password'),
                      const SizedBox(height: 5),
                      TextField(
                        controller: PasswordNoCtl,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(0, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF702D),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)), // มุมไม่โค้ง
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    var data = {
      "name": NameNoCtl.text,
      "password": PasswordNoCtl.text,
    };

    try {
      final response = await http.post(
        Uri.parse("$API_ENDPOINT/user/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // แปลงข้อมูลที่ได้รับจาก JSON เป็น List<LoginRes>
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<LoginRes> loginUsers =
            jsonResponse.map((user) => LoginRes.fromJson(user)).toList();

        // ตัวอย่างการใช้ข้อมูล
        for (var user in loginUsers) {
          log('ID: ${user.id}');
          log('Username: ${user.username}');
          log('Phone: ${user.phone}');
          log('User Type: ${user.userType}');

          int userId = user.id; // user.id เป็น user_id
          String userType = user.userType;

          if (userType == 'user') {
            // เรียก API เพื่อดึงข้อมูล UserProfile
            final userProfileResponse = await http.get(
              Uri.parse(
                  "$API_ENDPOINT/user/user_id?user_id=$userId"), // แก้ไขการเข้าถึง URL
              headers: {"Content-Type": "application/json; charset=utf-8"},
            );

            if (userProfileResponse.statusCode == 200) {
              // เก็บข้อมูลที่ได้รับจาก JSON ไว้
              UserProfile userProfile =
                  UserProfile.fromJson(jsonDecode(userProfileResponse.body)[0]);
              Provider.of<AppData>(context, listen: false)
                  .updateUser(userProfile);
            } else {
              log("เก็บข้อมูลไม่สำเร็จ");
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeUserPage(),
              ),
            );
            log('This user is a user.');
          } else if (userType == 'rider') {
            // เรียก API เพื่อดึงข้อมูล UserProfile
            final riderProfileResponse = await http.get(
              Uri.parse(
                  "$API_ENDPOINT/rider/rider_id?rider_id=$userId"), // แก้ไขการเข้าถึง URL
              headers: {"Content-Type": "application/json; charset=utf-8"},
            );

            if (riderProfileResponse.statusCode == 200) {
              // เก็บข้อมูลที่ได้รับจาก JSON ไว้
              RiderProfile riderProfile =
                  RiderProfile.fromJson(jsonDecode(riderProfileResponse.body)[0]);
              Provider.of<AppData>(context, listen: false)
                  .updateRider(riderProfile);

            } else {
              log("เก็บข้อมูลไม่สำเร็จ");
            }

            //  Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomeUserPage(),
            //   ),
            // );

            log('This user is a normal rider.');
            // คุณสามารถทำการนำทางไปยังหน้าสำหรับ rider ที่นี่ถ้าต้องการ
          }
        }
      } else {
        log('Failed to login: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (error) {
      log('Error: $error');
    }
  }
}
