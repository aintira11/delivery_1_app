import 'dart:developer';

import 'package:delivery_1_app/pages/rider/homeRider.dart';
import 'package:flutter/material.dart';
import 'package:delivery_1_app/pages/rider/mapRider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageConfirmPage extends StatefulWidget {
  const ImageConfirmPage({super.key});

  @override
  State<ImageConfirmPage> createState() => _ImageConfirmPageState();
}

class _ImageConfirmPageState extends State<ImageConfirmPage> {
  File? _image;
  String? _firebaseFileName;

  // ฟังก์ชันเลือกภาพจากกล้อง
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print('Image Path: ${_image!.path}'); // แสดงพาธของรูปที่ถ่าย
      });
    }
  }

  // ฟังก์ชันบันทึกรูปลง Firebase และ Local Storage
  Future<void> _saveImage() async {
    if (_image == null) return;

    // 1. อัปโหลดรูปภาพไปที่ Firebase Storage
    try {
      // ใช้ UUID สร้างชื่อไฟล์ที่ไม่ซ้ำกัน
      String fileName = '${Uuid().v4()}.jpg'; // สร้างชื่อไฟล์ที่ไม่ซ้ำกัน
      Reference ref = FirebaseStorage.instance.ref('status/$fileName');

      // อัปโหลดไฟล์ไปยัง Firebase Storage
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;

      // ดึง URL ของรูปภาพจาก Firebase
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        _firebaseFileName = fileName; // บันทึกชื่อไฟล์เพื่อใช้ในฐานข้อมูล
      });

      // Log การอัปโหลดสำเร็จ
      log('Image uploaded to Firebase with URL: $downloadUrl');
      log('Firebase File Name: $fileName');

      // 2. บันทึกรูปภาพลง Local Storage
      Directory appDir = await getApplicationDocumentsDirectory();
      String localPath = path.join(appDir.path, fileName);
      await _image!.copy(localPath);

      // Log การบันทึกลงเครื่องสำเร็จ
      log('Image saved to local storage: $localPath');
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ถ้าต้องการปิดการใช้งานปุ่มย้อนกลับ Return false
        //return false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ปิดการแสดงไอคอน Back
          title: Text('Order Confirmation'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.orange[100],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Number 99',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sender'),
                                Text('Name: Namin'),
                                Text('Phone: 0957455574'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sent to'),
                                Text('Name: Yoko'),
                                Text('Phone: 0988884599'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Distance: 20 Km',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Take a photo of the delivery',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 50),
                              SizedBox(height: 8),
                              Text('Show Image Here'),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 250, // กำหนดความกว้างเอง
                  height: 45, // กำหนดความสูงเอง
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[400],
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RiderHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300], // Green confirm button
                  minimumSize: Size(double.infinity, 50), // Button width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Complete',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
