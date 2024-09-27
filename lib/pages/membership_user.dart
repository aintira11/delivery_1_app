import 'dart:ffi';

import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/home.dart';
import 'package:delivery_1_app/pages/model/Request/memberUser_req.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; // นำเข้า Firebase Storage
import 'package:uuid/uuid.dart'; // ใช้สำหรับสร้าง UUID
import 'package:http/http.dart' as http;

class MemberUserPage extends StatefulWidget {
  const MemberUserPage({super.key});

  @override
  State<MemberUserPage> createState() => _MemberUserPageState();
}

class _MemberUserPageState extends State<MemberUserPage> {
  File? _image;
  String? _imageUrl;
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController addressNoCtl = TextEditingController();
  TextEditingController passwordNoCtl = TextEditingController();
  TextEditingController confirmpasswordNoCtl = TextEditingController();

  LatLng latLng = LatLng(15.998009549056942, 102.53815639596311);

  double latitude = 0.0; // Corrected variable type and initialized
  double longitude = 0.0;

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 183, 64),
        title: const Text(
          'Get Started',
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
                  child: Text('Address'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: TextField(
                    controller: addressNoCtl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text('Select Location'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var position = await _determinePosition();
                        log('${position.latitude} ${position.longitude}');
                        longitude = position.longitude;
                        latitude = position.latitude;
                        latLng = LatLng(position.latitude, position.longitude);
                        _showMap(); // Call _showMap here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: const Text(
                        'Show Map',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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

  void _showMap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Map'),
          content: SizedBox(
            width: double.maxFinite,
            height: 350,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: latLng,
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  // เมื่อมีการจิ้มที่แผนที่
                  _showCoordinates(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        point: LatLng(latitude, longitude), // ใช้ค่าที่เก็บไว้
                        width: 40,
                        height: 40,
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.motorcycle,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        alignment: Alignment.center),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCoordinates(LatLng point) {
    longitude = point.longitude;
    latitude = point.latitude;

    // แสดงพิกัดที่ถูกจิ้ม
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Coordinates'),
    //       content: Text(
    //           'Latitude: ${point.latitude}, Longitude: ${point.longitude}'),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('Close'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void register() async {
  // Check if the passwords match and all fields are filled
  if (passwordNoCtl.text == confirmpasswordNoCtl.text &&
      nameNoCtl.text.isNotEmpty &&
      phoneNoCtl.text.isNotEmpty &&
      addressNoCtl.text.isNotEmpty &&
      passwordNoCtl.text.isNotEmpty &&
      latitude != 0.0 && // Ensure latitude is set
      longitude != 0.0 && // Ensure longitude is set
      _imageUrl != null) { // Ensure image URL is set if required
    log("data");
    // Log the field values for debugging
    log('Name: ${nameNoCtl.text}');
    log('Phone: ${phoneNoCtl.text}');
    log('Address: ${addressNoCtl.text}');
    log('Password: ${passwordNoCtl.text}');
    log('Latitude: $latitude');
    log('Longitude: $longitude');
    log('Image URL: $_imageUrl');

    // Create an instance of MemberRes
    MemberRes req = MemberRes(
      name: nameNoCtl.text,
      password: passwordNoCtl.text,
      phone: phoneNoCtl.text,
      address: addressNoCtl.text,
      image: _imageUrl ?? "",
      latitude: latitude,
      longitude: longitude,
    );

    try {
      log("post");
      // Make the POST request
      final response = await http.post(
        Uri.parse("$API_ENDPOINT/memberUser"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: memberResToJson(req),
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
