import 'dart:convert';
import 'dart:developer';
import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/model/Response/AddItem_res.dart';
import 'package:delivery_1_app/pages/model/Response/getUsers_res.dart';
import 'package:delivery_1_app/pages/sender/comfirmImage.dart';
import 'package:firebase_storage/firebase_storage.dart'; // นำเข้า Firebase Storage
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // ใช้สำหรับสร้าง UUID
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class prodactPage extends StatefulWidget {
  final int id;
  prodactPage({super.key, required this.id});

  @override
  State<prodactPage> createState() => _prodactPageState();
}

class _prodactPageState extends State<prodactPage> {
  File? _image;
  String? _imageUrl;
  int? getOrder_id;
  TextEditingController detailNoCtl = TextEditingController();

  List<GetUsersRes> getUsers = []; // ตัวแปรเก็บข้อมูลจาก API
  List<GetAddItemRes> getAdd_item = [];
  late Future<void> loadData;
  late UserProfile user;

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;

    loadData = getMemberbyID(widget.id);
    order(user.userId, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a product'),
        //leading: Icon(Icons.arrow_back),
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading user data'));
            } else if (getUsers.isEmpty) {
              return const Center(child: Text('No user data available'));
            }
            // ใช้ข้อมูลผู้ใช้จาก getUsers ที่ได้จาก API
            final user = getUsers[0];
            return SingleChildScrollView(
              // ใช้ SingleChildScrollView เพื่อให้เลื่อนหน้าจอได้
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.brown[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${user.name}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Phone: ${user.phone}'),
                            const SizedBox(height: 8),
                            Text('Address: ${user.address}'),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                              controller: detailNoCtl,
                              decoration: InputDecoration(
                                labelText: 'Detail product',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true, // เปิดใช้งานพื้นหลังที่เต็ม
                                fillColor:
                                    Colors.white, // ตั้งค่าสีพื้นหลังเป็นสีขาว
                              ),
                              style: const TextStyle(
                                fontSize: 16, // ขนาดตัวอักษร
                                color: Colors.black, // สีตัวอักษรเป็นสีดำ
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                AddItem();
                              },
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap:
                          true, // ทำให้ ListView อยู่ภายใน ScrollView ได้
                      physics:
                          const NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
                      itemCount: getAdd_item.length, // จำนวน item ที่จะสร้าง
                      itemBuilder: (context, index) {
                        final item = getAdd_item[index]; // ข้อมูล item จาก list

                        return Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // แสดงรูปภาพจาก URL ที่ดึงมาจาก item.image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.image, // ดึง URL รูปจาก item.image
                                    height: 50,
                                    width: 50, // กำหนดขนาดรูปภาพ
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        16), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.detail, // แสดงรายละเอียดสินค้า
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Order ID: ${item.orderId}', // แสดง Order ID
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16), // เพิ่มระยะห่างก่อนปุ่ม "Next"
                    ElevatedButton(
                      onPressed: () {
                        // ตรวจสอบว่าผู้ใช้เพิ่มรายการสำเร็จหรือไม่ก่อนที่จะไปหน้าถัดไป
                        if (_imageUrl == null || getOrder_id == null) {
                          // ถ้ายังไม่ได้เพิ่มรายการหรือยังไม่มีการอัปโหลดรูป
                          const snackBar = SnackBar(
                              content:
                                  Text('กรุณาเพิ่มรายการและอัปโหลดรูปก่อน 🤔'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmImagePage(
                                  //id: widget.id, // ส่งค่า id ที่รับมาจากหน้าที่แล้ว
                                  order_id: getOrder_id?.toInt() ??
                                      0, // ส่ง order_id ที่เก็บไว้ ถ้าเป็น null ให้ใช้ค่า 0 แทน
                                  getUsers: getUsers),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize:
                            Size(double.infinity, 50), // ขนาดปุ่มให้เต็มจอ
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
            );
          }),
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

  Future<void> getMemberbyID(int id) async {
    int idx = id;
    log('Requested user ID: $idx');
    try {
      final res = await http.get(
        Uri.parse("$API_ENDPOINT/user/user_id?user_id=$idx"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);

        List<GetUsersRes> fetchedUsers = data.map((item) {
          return GetUsersRes.fromJson(item);
        }).toList();

        // เก็บข้อมูลที่ได้ลงในตัวแปร allUsers และอัปเดต UI
        setState(() {
          getUsers = fetchedUsers;
        });
      } else {
        log('Error fetching users: ${res.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

//สร้าง order id
  void order(int userId, int receiverId) async {
    log('sender_id user ID: $userId');
    log('receiver_id user ID: $receiverId');

    try {
      // สร้างข้อมูล JSON ที่ต้องการส่ง
      final body = jsonEncode({
        'sender_id': userId,
        'receiver_id': receiverId,
      });

      // ส่งคำขอ POST พร้อม body
      final res = await http.post(
        Uri.parse("$API_ENDPOINT/sender/createOrder"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: body, // ส่งข้อมูลใน body
      );

      if (res.statusCode == 201) {
        // รับ order_id จาก response โดยเข้าถึงค่าจากวัตถุ
        final orderId = jsonDecode(res.body)['order_id'];
        log('Order ID: $orderId'); // จะเป็นค่าตรงๆ ตอนนี้
        setState(() {
          getOrder_id = orderId; // อัปเดตสถานะด้วย order ID
        });
      } else {
        log('Error creating order: ${res.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  void AddItem() async {
    if (getOrder_id == null) {
      log('Order ID is null');
      return; // ออกจากฟังก์ชันถ้าหาก order_id เป็น null
    }
    int? order_id = getOrder_id;
    String detail = detailNoCtl.text.trim();
    if (_imageUrl == null) {
      // Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
      //     snackPosition: SnackPosition.TOP);
      const SnackBar(content: Text('เลือกสักรุปสิ 🤔.'));
    }
    log('order_id: $order_id');
    log('detail: $detail');
    log('Image URL: $_imageUrl');
    // สร้างข้อมูล JSON ที่ต้องการส่ง
    try {
      final body = jsonEncode({
        'order_id': order_id,
        'detail': detail,
        'image': _imageUrl,
      });

      // ส่งคำขอ POST พร้อม body
      final res = await http.post(
        Uri.parse("$API_ENDPOINT/sender/addItem"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: body, // ส่งข้อมูลใน body
      );

      if (res.statusCode == 201) {
        final dataItem = jsonDecode(res.body); // แปลง JSON เป็น Map

        // ตรวจสอบว่ามีการส่งกลับ order_id หรือไม่
        if (dataItem.containsKey('order_id')) {
          // แสดงผล order_id หรือข้อมูลที่คุณต้องการใช้
          log('Item added with order ID: ${dataItem['order_id']}');
          // หากคุณต้องการเก็บข้อมูล item ใหม่ใน getAdd_item
          setState(() {
            getAdd_item.add(GetAddItemRes.fromJson(dataItem));
          });
        } else {
          log('No order_id found in response');
        }
      } else {
        log('Error creating order: ${res.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
