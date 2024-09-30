import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/pages/home.dart';
import 'package:delivery_1_app/pages/model/Request/memberUser_req.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart'; // เพิ่มการนำเข้า geocoding

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
  double latitude = 0.0;
  double longitude = 0.0;
  MapController mapController = MapController();
  List<Marker> markers = [];
  
  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        latLng = LatLng(
            position.latitude, position.longitude); // อัปเดตค่าตำแหน่งเริ่มต้น
        latitude = position.latitude; // อัปเดตค่า latitude
        longitude = position.longitude; // อัปเดตค่า longitude
      });
    }).catchError((error) {
      log('Error getting current position: $error');
    });
  }

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
                  child: Text('Select Location'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        _showMap();
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
                  onPressed: () {
                    register();
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
        Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
            snackPosition: SnackPosition.TOP);
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

  Future<void> _showMap() async {
    showDialog(
      context: context,
      builder: (context) {
        LatLng tempLatLng =
            latLng; // เก็บพิกัดชั่วคราวสำหรับการอัปเดตภายใน dialog
        return AlertDialog(
          title: const Text('Map'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: StatefulBuilder(
              builder: (context, setState) {
                return FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        tempLatLng, // Set the initial center of the map
                    initialZoom: 13.0, // Set the initial zoom level
                    onTap: (tapPosition, point) {
                      // Update coordinates when tapping on the map
                      setState(() {
                        tempLatLng = point; // อัปเดตค่าพิกัดชั่วคราวใน dialog
                        latitude = point.latitude; // อัปเดต latitude
                        longitude = point.longitude; // อัปเดต longitude
                        _updateAddress(
                            point); // เรียกใช้งานฟังก์ชันเพื่ออัปเดตที่อยู่
                        log('Latitude: ${point.latitude}, Longitude: ${point.longitude}'); // Log ค่าใหม่
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: tempLatLng,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // อัปเดตค่าพิกัดสุดท้ายก่อนปิด dialog
                setState(() {
                  latLng = tempLatLng;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAddress(LatLng point) async {
    try {
      // แปลงพิกัด GPS เป็นที่อยู่
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      // รับที่อยู่และอัปเดตใน TextField
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
        setState(() {
          addressNoCtl.text = address; // อัปเดตที่อยู่ใน TextField
        });
      }
    } catch (e) {
      log('Error getting address: $e');
    }
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
    LocationPermission permission;

    // ตรวจสอบสถานะการอนุญาต
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permissions are denied');
      }
    }

    // รับพิกัดปัจจุบัน
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void register() async {
    // รับค่าจาก controller และใช้ trim เพื่อลบช่องว่าง
    String name = nameNoCtl.text.trim();
    String phone = phoneNoCtl.text.trim();
    String address = addressNoCtl.text.trim();
    String password = passwordNoCtl.text.trim();
    String confirmPassword = confirmpasswordNoCtl.text.trim();

    if (passwordNoCtl.text != confirmpasswordNoCtl.text) {
      Get.snackbar('Message Error !!!', 'รหัสผ่านไม่ถูกต้อง ลองใหม่อีกครั้ง ',
          snackPosition: SnackPosition.TOP);
    }
    if (_imageUrl == null) {
      Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
          snackPosition: SnackPosition.TOP);
    }
    if (phone.length != 10) {
      Get.snackbar(
          'Message Error !!!', 'Phone number must be exactly 10 digits',
          snackPosition: SnackPosition.TOP);
      //errorMessage = 'Phone number must be exactly 10 digits';
    }

    if (name == null || name.isEmpty) {
      Get.snackbar('Message Error !!!', 'ตั้งชื่อให้หน่อย 🥹',
          snackPosition: SnackPosition.TOP);
    }
    

    // ตรวจสอบว่าฟิลด์ทั้งหมดไม่ว่างเปล่า, null, และเบอร์โทรศัพท์มีความยาว 10 หลัก
    if (password == confirmPassword &&
        name.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        password.isNotEmpty &&
        phone.length == 10 && // เช็คเบอร์โทรศัพท์ต้องเป็น 10 ตัว
        latitude != 0.0 && // เช็ค latitude
        longitude != 0.0 && // เช็ค longitude
        _imageUrl != null) {
      // เช็คว่า image URL ถูกเซ็ตหรือไม่

      log("data");

      // Log field values สำหรับการ debug
      log('Name: $name');
      log('Phone: $phone');
      log('Address: $address');
      log('Password: $password');
      log('Latitude: $latitude');
      log('Longitude: $longitude');
      log('Image URL: $_imageUrl');

      // สร้าง instance ของ MemberRes
      MemberRes req = MemberRes(
        name: name,
        password: password,
        phone: phone,
        address: address,
        image: _imageUrl ?? "",
        latitude: latitude,
        longitude: longitude,
      );

      try {
        log("post");
        // ทำการส่งคำขอ POST ไปยัง backend
        final response = await http.post(
          Uri.parse("$API_ENDPOINT/user/memberUser"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: memberResToJson(req),
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
            const SnackBar(content: Text('Registration failed I already have this phone number.')),
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
      //  Get.snackbar('Message Error !!!', 'ใส่ข้อมูลไม่ครบ 🥹',
      //       snackPosition: SnackPosition.TOP);
      String errorMessage =
          'Please fill all fields';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      //  if (phone.length != 10) {
      //   Get.snackbar('Message Error !!!', 'Phone number must be exactly 10 digits',
      //       snackPosition: SnackPosition.TOP);
      //   errorMessage = 'Phone number must be exactly 10 digits';
      // }
    }
  }
}
