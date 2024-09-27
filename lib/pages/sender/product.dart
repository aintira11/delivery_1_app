import 'dart:developer';
import 'package:delivery_1_app/pages/sender/comfirmImage.dart';
import 'package:firebase_storage/firebase_storage.dart'; // นำเข้า Firebase Storage
import 'package:uuid/uuid.dart'; // ใช้สำหรับสร้าง UUID
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class prodactPage extends StatefulWidget {
  const prodactPage({super.key});

  @override
  State<prodactPage> createState() => _prodactPageState();
}

class _prodactPageState extends State<prodactPage> {
  File? _image;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a product'),
        //leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อให้เลื่อนหน้าจอได้
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: Yoko',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Phone: 0111111111'),
                      SizedBox(height: 8),
                      Text('Address: 88/1 aaa kkk mkmk'),
                    ],
                  ),
                ),
              ),
              Divider(height: 32),
              // Card wrapping the image picker, text field, and button
              Card(
                elevation: 4,
                color: Colors.white, // Set to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: 2,
                            ),
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
                                    Icon(Icons.image, size: 40),
                                    SizedBox(height: 8),
                                    Text('Open Gallery'),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Detail product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true, // เปิดใช้งานพื้นหลังที่เต็ม
                          fillColor: Colors.white, // ตั้งค่าสีพื้นหลังเป็นสีขาว
                        ),
                        style: const TextStyle(
                          fontSize: 16, // ขนาดตัวอักษร
                          color: Colors.black, // สีตัวอักษรเป็นสีดำ
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Add Items'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // สีปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // แสดงรูปภาพ
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!,
                                height: 50,
                                width: 50, // กำหนดความกว้างของรูปภาพ
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors
                                    .grey[200], // สีพื้นหลังสำหรับกรณีไม่มีรูป
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(Icons.image, size: 40),
                              ),
                            ),
                      const SizedBox(
                          width: 16), // ระยะห่างระหว่างรูปภาพกับข้อความ
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Name', // ชื่อผลิตภัณฑ์
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // const SizedBox(height: 4),
                            // const Text(
                            //   'Product Description', // รายละเอียดผลิตภัณฑ์
                            //   style: TextStyle(fontSize: 14),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16), // เพิ่มระยะห่างก่อนปุ่ม "Next"
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfirmImagePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50), // ขนาดปุ่มให้เต็มจอ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 20),
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
      Reference ref = FirebaseStorage.instance.ref('product/$fileName');

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
}
