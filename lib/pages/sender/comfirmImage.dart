import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/internal_config.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/model/Response/getDataOrder_res.dart';
import 'package:delivery_1_app/pages/model/Response/getUsers_res.dart';
import 'package:delivery_1_app/pages/sender/Maindrawer.dart';
import 'package:firebase_storage/firebase_storage.dart'; // นำเข้า Firebase Storage
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ConfirmImagePage extends StatefulWidget {
  //final int id;
  final String order_id;
  final List<GetUsersRes> getUsers;
  ConfirmImagePage({super.key, required this.order_id, required this.getUsers});

  @override
  State<ConfirmImagePage> createState() => _ConfirmImagePageState();
}

class _ConfirmImagePageState extends State<ConfirmImagePage> {
  File? _image;
  String? _imageUrl;
  late UserProfile user;
  //late List<GetUsersRes> getUsers; // ประกาศตัวแปร getUsers
  late Future<void> loadData;
  //List<GetDataOrderRes> dataOrder = [];
  GetDataOrderRes? dataOrder;
  List<Item> fetchedItems = []; // ตัวแปรสำหรับเก็บข้อมูลสินค้า

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    //getUsers = widget.getUsers; // ดึงข้อมูลจาก widget.getUsers มาเก็บในตัวแปร
    DataOrder(widget.order_id);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Information Section
              Card(
                color: Colors.orange[100],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sent to',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Name: ${widget.getUsers[0].name}'),
                      Text('Phone: ${widget.getUsers[0].phone}'),
                      Text('Address: ${widget.getUsers[0].address}'),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Order Number : ${widget.order_id}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (fetchedItems.isNotEmpty)
                        Column(
                          children: fetchedItems.map((item) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(item.image, width: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.detail, style: const TextStyle(fontSize: 16)),
                              ),
                            ],
                          )).toList(),
                        )
                      else
                        const Text('No items found for this order'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Camera button and photo display
              const Center(
                child: Text(
                  'ถ่ายรูปประกอบสถานะ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
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
                              Text('แสดงรูปภาพ'),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Camera',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Adding spacing between elements

              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  status1(widget.order_id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18),
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
          await picker.pickImage(source: ImageSource.camera);

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
      Reference ref = FirebaseStorage.instance.ref('status/$fileName');

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

  // void DataOrder(String idx) async {
  //   try {
  //     final res = await http.get(
  //       Uri.parse("$API_ENDPOINT/sender/getDataOrder?order_id=$idx"),
  //       headers: {"Content-Type": "application/json; charset=utf-8"},
  //     );

  //     if (res.statusCode == 200) {
  //       // แปลง JSON จาก Response เป็น Map
  //       Map<String, dynamic> jsonData = jsonDecode(res.body);

  //       // ตรวจสอบว่า 'items' มีอยู่
  //       List<dynamic> itemsData = jsonData['items'];

  //       // แปลง itemsData เป็น List ของ Item
  //       List<Item> fetchedItems = itemsData.map((item) {
  //         return Item.fromJson(item); // ใช้ Item แทน GetDataOrderRes
  //       }).toList();

  //       // สร้าง GetDataOrderRes จากข้อมูลที่ได้
  //       GetDataOrderRes dataOrderRes = GetDataOrderRes(
  //         orderId: jsonData['order_id'],
  //         items: fetchedItems,
  //       );

  //       // เก็บข้อมูลที่ได้ลงในตัวแปร dataOrder และอัปเดต UI
  //       setState(() {
  //         dataOrder = dataOrderRes; // เก็บข้อมูลในรูปแบบ GetDataOrderRes
  //       });

  //       // Log ข้อมูลใน dataOrder
  //       log('DataOrder: ${jsonEncode(dataOrder)}'); // แสดงข้อมูลในรูปแบบ JSON
  //     } else {
  //       log('Error fetching users: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Error: $e');
  //   }
  // }

  void DataOrder(String orderId) async {
    log('Requesting order data for order_id: $orderId');

    try {
      DocumentReference orderDocRef =
          FirebaseFirestore.instance.collection('Orders').doc(orderId);
      DocumentSnapshot orderSnapshot = await orderDocRef.get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData =
            orderSnapshot.data() as Map<String, dynamic>;
        List<dynamic> itemsData = orderData['items'] ?? [];

        // แปลง itemsData เป็น List ของ Item
        List<Item> fetchedItems = itemsData.map((item) {
          return Item.fromJson(item);
        }).toList();

        // อัปเดต UI โดยใช้ setState
        setState(() {
          this.fetchedItems = fetchedItems; // อัปเดต fetchedItems ที่ใช้ใน UI
        });

        log('Fetched items: ${jsonEncode(fetchedItems.map((item) => item.toJson()).toList())}');
      } else {
        log('No orders found with order_id: $orderId');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

//   Future<void> status1(String id) async {
//     log('order_id: $id');
//     log('Image URL: $_imageUrl');
//     if (_imageUrl == null) {
//       // Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
//       //     snackPosition: SnackPosition.TOP);
//       const SnackBar(content: Text('ลืมกดถ่ายภาพ 🤔.'));
//     }
//     // สร้างข้อมูล JSON ที่ต้องการส่ง
//     try {
//       final body = jsonEncode({
//         'order_id': id,
//         'image_status_1': _imageUrl,
//       });
//       log(body);
//       // ส่งคำขอ POST พร้อม body
//       final res = await http.put(
//         Uri.parse("$API_ENDPOINT/sender/addStatus_1"),
//         headers: {
//           "Content-Type": "application/json; charset=utf-8",
//         },
//         body: body, // ส่งข้อมูลใน body
//       );

//       if (res.statusCode == 200) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MainDrawerPage(value: 2)),
//         );
//         final status = jsonDecode(res.body); // แปลง JSON เป็น Map

//         // ตรวจสอบว่ามีการส่งกลับ หรือไม่
//         if (status.containsKey('message')) {
//           log('Item added with order ID: ${status['message']}');
//         } else {
//           log('No order_id found in response');
//         }
//       } else {
//         log('Error creating order: ${res.statusCode}');
//       }
//     } catch (e) {
//       log('Error: $e');
//     }
//   }
// }
Future<void> status1(String orderId) async {
  log('Updating order with order_id: $orderId');
  log('Image URL: $_imageUrl');

  try {
    // อ้างอิงไปยังเอกสารใน collection "Orders"
    DocumentReference orderDocRef = FirebaseFirestore.instance.collection('Orders').doc(orderId);

    // ใช้ Transaction ในการอัปเดตเพื่อให้แน่ใจว่าการอัปเดตจะถูกทำในลักษณะ atomic
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // ดึงข้อมูลเอกสารมาเพื่อแก้ไข
      DocumentSnapshot snapshot = await transaction.get(orderDocRef);

      if (snapshot.exists) {
        // ข้อมูลที่มีอยู่ใน 'status_history'
        List<dynamic> statusHistory = snapshot.get('status_history') ?? [];

        // แก้ไข status ล่าสุดใน statusHistory
        if (statusHistory.isNotEmpty) {
          // ดึงสถานะล่าสุดที่อยู่ใน array
          Map<String, dynamic> lastStatus = statusHistory.last;
          
          // แก้ไข 'image_url_1' และ 'status'
          lastStatus['image_url_1'] = _imageUrl;
          lastStatus['status'] = 'รอไรด์เดอร์';

          // อัปเดต statusHistory ใหม่
          transaction.update(orderDocRef, {'status_history': statusHistory});
          
          log('Order updated successfully.');
           Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainDrawerPage(value: 2)),
        );
        } else {
          log('No status history found.');
        }
      } else {
        log('Order not found.');
      }
    });

  } catch (e) {
    log('Error updating order: $e');
  }
}

}

class Item {
  String detail;
  String image;

  Item({required this.detail, required this.image});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      detail: json['detail'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // เพิ่มฟังก์ชัน toJson
  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'image': image,
    };
  }
}
