
import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/home.dart';
import 'package:delivery_1_app/pages/model/Request/memberRider_req.dart';
import 'package:flutter/material.dart';
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap:(){_pickImage();} ,
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
                  child: TextField(
                    controller: nameNoCtl,
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
                  child: TextField(
                    controller: phoneNoCtl,
                    keyboardType: TextInputType.phone,
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
                  child: TextField(
                    controller: vehicleNoCtl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                ),
                
                // const SizedBox(height: 5,),
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
                  child: TextField(
                    controller: passwordNoCtl,
                    obscureText: true,
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
                  child: TextField(
                    controller: confirmpasswordNoCtl,
                    obscureText: true,
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
                  onPressed:(){register();} ,
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
    );
  }

void _pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
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
  // Check if the passwords match and all fields are filled
  if (passwordNoCtl.text == confirmpasswordNoCtl.text &&
      nameNoCtl.text.isNotEmpty &&
      phoneNoCtl.text.isNotEmpty &&
      vehicleNoCtl.text.isNotEmpty &&
      passwordNoCtl.text.isNotEmpty &&
      _imageUrl != null) { // Ensure image URL is set if required
    log("data");
    // Log the field values for debugging
    log('Name: ${nameNoCtl.text}');
    log('Phone: ${phoneNoCtl.text}');
    log('vehicle: ${vehicleNoCtl.text}');
    log('Password: ${passwordNoCtl.text}');
    log('Image URL: $_imageUrl');

    // Create an instance of MemberRes
    RiderRes req = RiderRes(
      riderName: nameNoCtl.text,
      riderPassword: passwordNoCtl.text,
      riderPhone: phoneNoCtl.text,
      riderImage: _imageUrl ?? "",
      vehicle: vehicleNoCtl.text,
    );

    try {
      log("post");
      // Make the POST request
      final response = await http.post(
        Uri.parse("$API_ENDPOINT/memberRider"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: riderResToJson(req),
      );

      // Check the response status
      if (response.statusCode == 200) {
        log('User registered successfully: ${response.body}');
        // Navigate to the home page upon successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        log('Failed to register user: ${response.body}');
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (error) {
      log('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration: $error')),
      );
    }
  } else {
    // Handle validation error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please fill all fields and ensure passwords match')),
    );
  }
}

}