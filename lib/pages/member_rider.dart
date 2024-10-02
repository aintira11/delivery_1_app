import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/home.dart';
import 'package:delivery_1_app/pages/model/Request/memberRider_req.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // นำเข้า Firebase Storage
import 'package:uuid/uuid.dart'; // ใช้สำหรับสร้าง UUID
import 'package:http/http.dart' as http;

class memberRiderPage extends StatefulWidget {
  const memberRiderPage({super.key});

  @override
  State<memberRiderPage> createState() => _memberRiderPageState();
}

class _memberRiderPageState extends State<memberRiderPage> {
  final _formKey = GlobalKey<FormState>(); // สร้าง GlobalKey สำหรับฟอร์ม
  File? _image;
  String? _imageUrl;
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController vehicleNoCtl = TextEditingController();
  TextEditingController passwordNoCtl = TextEditingController();
  TextEditingController confirmpasswordNoCtl = TextEditingController();

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 183, 64),
        title: const Text(
          'Get Started For Rider',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 253, 239, 202),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // ผูกฟอร์มกับ GlobalKey
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: TextFormField(
                      controller: nameNoCtl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อ';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Phone number'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: TextFormField(
                      controller: phoneNoCtl,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกหมายเลขโทรศัพท์';
                        } else if (value.length != 10) {
                          return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('motor vehicle registration'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: TextFormField(
                      controller: vehicleNoCtl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกเลขทะเบียนรถ';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Divider(color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Password'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                    child: TextFormField(
                      controller: passwordNoCtl,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Confirm password'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                    child: TextFormField(
                      controller: confirmpasswordNoCtl,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณายืนยันรหัสผ่าน';
                        } else if (value != passwordNoCtl.text) {
                          return 'รหัสผ่านไม่ตรงกัน';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ตรวจสอบฟอร์ม
                      if (_formKey.currentState?.validate() ?? false) {
                        // ถ้าผ่านการตรวจสอบ ให้ดำเนินการลงทะเบียน
                        register();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF702D),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImage(_image!);
        log("ImageUrl");
      } else {
        log("No image selected");
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      log("filename");
      String fileName = '${Uuid().v4()}.jpg'; // เปลี่ยนชื่อไฟล์ให้ไม่ซ้ำ
      Reference ref = FirebaseStorage.instance.ref('delivery/$fileName');

      // อัปโหลดไฟล์ไปยัง Firebase Storage
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      log("url");
      // ตรวจสอบสถานะการอัปโหลด
      if (snapshot.state == TaskState.success) {
        // รับ URL ของรูปภาพที่อัปโหลด
        _imageUrl = await ref.getDownloadURL();
        log('Image uploaded successfully: $_imageUrl'); // แสดง URL ใน log
      } else {
        log('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  void register() async {
    // รับค่าจาก controller และใช้ trim เพื่อลบช่องว่าง
    String name = nameNoCtl.text.trim();
    String phone = phoneNoCtl.text.trim();
    String vehicle = vehicleNoCtl.text.trim();
    String password = passwordNoCtl.text.trim();
    String confirmPassword = confirmpasswordNoCtl.text.trim();

    if (passwordNoCtl.text != confirmpasswordNoCtl.text) {
      // Get.snackbar('Message Error !!!', 'รหัสผ่านไม่ถูกต้อง ลองใหม่อีกครั้ง ',
      //     snackPosition: SnackPosition.TOP);
       const SnackBar(
                content: Text(
                    'รหัสผ่านไม่ถูกต้อง ลองใหม่อีกครั้ง.'));
    } else if (_imageUrl == null) {
      // Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
      //     snackPosition: SnackPosition.TOP);
       const SnackBar(
                content: Text(
                    'เลือกสักรุปสิ 🤔.'));
    } 
    //else if (name == null || name.isEmpty) {
    //   Get.snackbar('Message Error !!!', 'ตั้งชื่อให้หน่อย 🥹',
    //       snackPosition: SnackPosition.TOP);
    // } else if (phone.length != 10) {
    //   Get.snackbar(
    //       'Message Error !!!', 'Phone number must be exactly 10 digits',
    //       snackPosition: SnackPosition.TOP);
    //   //errorMessage = 'Phone number must be exactly 10 digits';
    // } else if (vehicle == null || vehicle.isEmpty) {
    //   Get.snackbar('Message Error !!!', 'มีรถขับป่าว',
    //       snackPosition: SnackPosition.TOP);
    // }

    // ตรวจสอบว่ารหัสผ่านตรงกัน, เบอร์โทรศัพท์มีความยาว 10 หลัก และทุก field ไม่เป็นค่าว่างหรือ null
    if (password == confirmPassword &&
        name.isNotEmpty &&
        phone.isNotEmpty &&
        vehicle.isNotEmpty &&
        password.isNotEmpty &&
        _imageUrl != null) {
      // ตรวจสอบเบอร์โทรศัพท์ว่ามีความยาว 10 หลักหรือไม่
      if (phone.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number must be 10 digits long')),
        );
        return; // หยุดการทำงานถ้าเบอร์โทรไม่ถูกต้อง
      }

      log("data");

      // Log field values สำหรับการ debug
      log('Name: $name');
      log('Phone: $phone');
      log('Vehicle: $vehicle');
      log('Password: $password');
      log('Image URL: $_imageUrl');

      // สร้าง instance ของ RiderRes
      RiderRes req = RiderRes(
        riderName: name,
        riderPassword: password,
        riderPhone: phone,
        riderImage: _imageUrl ?? "",
        vehicle: vehicle,
      );

      try {
        log("post");
        // ทำการส่งคำขอ POST ไปยัง backend
        final response = await http.post(
          Uri.parse("$API_ENDPOINT/rider/memberRider"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: riderResToJson(req),
        );

        // ตรวจสอบสถานะการตอบกลับ
        if (response.statusCode == 200) {
          log('User registered successfully: ${response.body}');
          // นำทางไปยังหน้า home หากการสมัครสำเร็จ
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          log('Failed to register user: ${response.body}');
          // แสดงข้อผิดพลาดผ่าน SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Registration failed I already have this phone number.')),
          );
        }
      } catch (error) {
        log('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during registration: $error')),
        );
      }
    } else {
      // แสดงข้อผิดพลาดหากข้อมูลไม่ถูกต้อง

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    }
  }
}
