import 'dart:convert';
import 'dart:developer';

import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/home.dart';
import 'package:delivery_1_app/pages/home_user.dart';
import 'package:delivery_1_app/pages/model/Response/login_res.dart';
import 'package:delivery_1_app/pages/rider/homeRider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController PhoneNoCtl = TextEditingController();
  TextEditingController PasswordNoCtl = TextEditingController();

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // ผูกฟอร์มกับ GlobalKey
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
                        const Text('Phone number'),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: PhoneNoCtl,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกหมายเลขโทรศัพท์';
                            } else if (value.length != 10) {
                              return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: PasswordNoCtl,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            }
                            return null;
                          },
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
                              // ตรวจสอบฟอร์ม
                              if (_formKey.currentState!.validate()) {
                                // ถ้าฟอร์มผ่านการ validate
                                login();
                              } else {
                                // แสดงข้อผิดพลาดถ้าฟอร์มไม่ผ่านการ validate
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                              }
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
      ),
    );
  }

  // void login() async {
  //   String phone = PhoneNoCtl.text.trim();
  //   String password = PasswordNoCtl.text.trim();

  //   if (phone.isEmpty || password.isEmpty) {
  //     // แสดงข้อความแจ้งเตือนเมื่อเบอร์โทรศัพท์หรือรหัสผ่านว่างเปล่า
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Error'),
  //         content: const Text(
  //             'Phone number and password cannot be empty or contain only spaces'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }

  //   // เตรียมข้อมูลสำหรับส่งไปยัง backend
  //   var data = {
  //     "phone": phone,
  //     "password": password,
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse("$API_ENDPOINT/user/login"),
  //       headers: {"Content-Type": "application/json; charset=utf-8"},
  //       body: jsonEncode(data),
  //     );

  //     if (response.statusCode == 200) {
  //       // แปลงข้อมูลที่ได้รับจาก JSON เป็น Map
  //       var jsonResponse = jsonDecode(response.body);
  //       // สร้าง LoginRes จาก Map
  //       LoginRes loginUser = LoginRes.fromJson(jsonResponse);

  //       log('ID: ${loginUser.id}');
  //       log('Username: ${loginUser.username}');
  //       log('Phone: ${loginUser.phone}');
  //       log('User Type: ${loginUser.userType}');

  //       // ทำงานต่อไปตามประเภทของผู้ใช้
  //       int userId = loginUser.id;
  //       String userType = loginUser.userType;

  //       if (userType == 'user') {
  //         final userProfileResponse = await http.get(
  //           Uri.parse("$API_ENDPOINT/user/user_id?user_id=$userId"),
  //           headers: {"Content-Type": "application/json; charset=utf-8"},
  //         );

  //         if (userProfileResponse.statusCode == 200) {
  //           UserProfile userProfile =
  //               UserProfile.fromJson(jsonDecode(userProfileResponse.body)[0]);
  //           Provider.of<AppData>(context, listen: false)
  //               .updateUser(userProfile);
  //         } else {
  //           log("เก็บข้อมูลไม่สำเร็จ");
  //         }

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => HomeUserPage(),
  //           ),
  //         );
  //         log('This user is a user.');
  //       } else if (userType == 'rider') {
  //         final riderProfileResponse = await http.get(
  //           Uri.parse("$API_ENDPOINT/rider/rider_id?rider_id=$userId"),
  //           headers: {"Content-Type": "application/json; charset=utf-8"},
  //         );

  //         if (riderProfileResponse.statusCode == 200) {
  //           RiderProfile riderProfile =
  //               RiderProfile.fromJson(jsonDecode(riderProfileResponse.body)[0]);
  //           Provider.of<AppData>(context, listen: false)
  //               .updateRider(riderProfile);

  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => RiderHomePage(),
  //             ),
  //           );
  //         } else {
  //           log("เก็บข้อมูลไม่สำเร็จ");
  //         }

  //         log('This user is a normal rider.');
  //       }
  //     } else {
  //       log('Failed to login: ${response.statusCode}');
  //       log('Response body: ${response.body}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User not found !!!!! '),
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     log('Error: $error');
  //   }
  // }


void login() async {
  String phone = PhoneNoCtl.text.trim();
  String password = PasswordNoCtl.text.trim();

  if (phone.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text(
            'Phone number and password cannot be empty or contain only spaces'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String documentId = querySnapshot.docs.first.id;

      String userType = userDoc['type'] ?? '';

      if (userType == 'user') {
        UserProfile userProfile = UserProfile(
          id: documentId, // แก้ไขการเข้าถึงค่า 'id'
          name: userDoc['name'] ?? '', // แก้ไขการเข้าถึงค่า 'name'
          phone: userDoc['phone'] ?? '', // แก้ไขการเข้าถึงค่า 'phone'
          address: userDoc['address'] ?? '', // แก้ไขการเข้าถึงค่า 'address'
          image: userDoc['image'] ?? '', // แก้ไขการเข้าถึงค่า 'image'
          latitude: double.tryParse(userDoc['latitude']?.toString() ?? '0.0') ?? 0.0,
          longitude: double.tryParse(userDoc['longitude']?.toString() ?? '0.0') ?? 0.0,
          type: userDoc['type'] ?? '',
        );

        Provider.of<AppData>(context, listen: false).updateUser(userProfile);

        log('Document ID: $documentId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeUserPage(),
          ),
        );

        log('This user is a user.');
      } else if (userType == 'rider') {
        RiderProfile riderProfile = RiderProfile(
          id: documentId, // แก้ไขการเข้าถึงค่า 'id'
          name: userDoc['name'] ?? '', // แก้ไขการเข้าถึงค่า 'name'
          phone: userDoc['phone'] ?? '', // แก้ไขการเข้าถึงค่า 'phone'
          image: userDoc['image'] ?? '', // แก้ไขการเข้าถึงค่า 'image'
          vehicle: userDoc['vehicle'] ?? '', // แก้ไขการเข้าถึงค่า 'vehicle'
          type: userDoc['type'] ?? '',
        );

        Provider.of<AppData>(context, listen: false).updateRider(riderProfile);

        log('Document ID: $documentId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RiderHomePage(),
          ),
        );

        log('This user is a rider.');
      } else {
        log('Unknown user type');
      }
    } else {
      log('User not found or incorrect password');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบผู้ใช้หรือรหัสผ่านไม่ถูกต้อง!'),
        ),
      );
    }
  } catch (error) {
    log('Error: $error');
  }
}


}
