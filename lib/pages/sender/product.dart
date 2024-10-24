
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
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
//import 'package:http/http.dart' as http;

class prodactPage extends StatefulWidget {
  final String id;
  prodactPage({super.key, required this.id});

  @override
  State<prodactPage> createState() => _prodactPageState();
}

class _prodactPageState extends State<prodactPage> {
  File? _image;
  String? _imageUrl;
  String? getOrder_id;
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
    order(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            // เช็คว่า getOrder_id ไม่เป็น null
            if (getOrder_id != null) {
              try {
                // อ้างอิงไปยัง collection "Orders"
                DocumentReference orderDocRef = FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(getOrder_id);

                // ลบเอกสารที่เกี่ยวข้องกับ order_id
                await orderDocRef.delete();
                log('Order with ID: $getOrder_id deleted successfully.');
              } catch (e) {
                log('Error deleting order: $e');
              }
            }

            // กลับไปยังหน้าก่อนหน้า
            Navigator.pop(context);
          },
        ),
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
                                    "${item.image}", // ดึง URL รูปจาก item.image
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
                                        '${item.detail}', // แสดงรายละเอียดสินค้า
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Order ID: ${item.order_id}', // แสดง Order ID
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
                                order_id: getOrder_id ?? "",
                                getUsers: getUsers,
                              ),
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

  Future<void> getMemberbyID(String id) async {
    log('Requested user ID: $id');
    try {
      // ดึงข้อมูลจาก Firestore โดยใช้ Document ID
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();

      if (doc.exists) {
        // แปลงข้อมูลจาก DocumentSnapshot เป็น GetUsersRes
        GetUsersRes user =
            GetUsersRes.fromJson(doc.data() as Map<String, dynamic>, doc.id);

        // เก็บข้อมูลที่ได้ลงในตัวแปร getUsers และอัปเดต UI
        setState(() {
          getUsers = [user]; // แปลงให้เป็น List
        });
      } else {
        log('User not found for ID: $id');
      }
    } catch (e) {
      log('Error fetching user: $e');
    }
  }

//สร้าง order id
  // void order(int userId, int receiverId) async {
  //   log('sender_id user ID: $userId');
  //   log('receiver_id user ID: $receiverId');

  //   try {
  //     // สร้างข้อมูล JSON ที่ต้องการส่ง
  //     final body = jsonEncode({
  //       'sender_id': userId,
  //       'receiver_id': receiverId,
  //     });

  //     // ส่งคำขอ POST พร้อม body
  //     final res = await http.post(
  //       Uri.parse("$API_ENDPOINT/sender/createOrder"),
  //       headers: {
  //         "Content-Type": "application/json; charset=utf-8",
  //       },
  //       body: body, // ส่งข้อมูลใน body
  //     );

  //     if (res.statusCode == 201) {
  //       // รับ order_id จาก response โดยเข้าถึงค่าจากวัตถุ
  //       final orderId = jsonDecode(res.body)['order_id'];
  //       log('Order ID: $orderId'); // จะเป็นค่าตรงๆ ตอนนี้
  //       setState(() {
  //         getOrder_id = orderId; // อัปเดตสถานะด้วย order ID
  //       });
  //     } else {
  //       log('Error creating order: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Error: $e');
  //   }
  // }
void order(String receiverId) async {
  log('sender_id user ID: $user');
  log('receiver_id user ID: $receiverId');

  try {
    // สร้างข้อมูลที่ต้องการบันทึกใน Cloud Firestore
    final orderData = {
      'sender_id': user.id,
      'receiver_id': receiverId,
      'rider_id': null,
      'status_history': [
        {
          'status': 'pending',
          // 'timestamp': Timestamp.now(),
          'note': 'Order created',
          'image_url_1': null,
          'image_url_2': null,
          'image_url_4': null,
        }
      ],
      'items': [] // สร้าง array ว่างสำหรับเก็บข้อมูลสินค้า
    };

    // เพิ่มข้อมูลลงใน collection 'Orders'
    final docRef =
        await FirebaseFirestore.instance.collection('Orders').add(orderData);

    // รับ order_id ที่ได้จาก Firestore
    final orderId = docRef.id;
    log('Order ID: $orderId'); // จะแสดงค่าของเอกสารที่สร้างขึ้น
    setState(() {
      getOrder_id = orderId; // อัปเดตสถานะด้วย order ID
    });
  } catch (e) {
    log('Error: $e');
  }
}


  // void AddItem() async {
  //   if (getOrder_id == null) {
  //     log('Order ID is null');
  //     return; // ออกจากฟังก์ชันถ้าหาก order_id เป็น null
  //   }
  //   String? order_id = getOrder_id;
  //   String detail = detailNoCtl.text.trim();
  //   if (_imageUrl == null) {
  //     // Get.snackbar('Message Error !!!', 'เลือกสักรุปสิ 🤔',
  //     //     snackPosition: SnackPosition.TOP);
  //     const SnackBar(content: Text('เลือกสักรุปสิ 🤔.'));
  //   }
  //   log('order_id: $order_id');
  //   log('detail: $detail');
  //   log('Image URL: $_imageUrl');
  //   // สร้างข้อมูล JSON ที่ต้องการส่ง
  //   try {
  //     final body = jsonEncode({
  //       'order_id': order_id,
  //       'detail': detail,
  //       'image': _imageUrl,
  //     });

  //     // ส่งคำขอ POST พร้อม body
  //     final res = await http.post(
  //       Uri.parse("$API_ENDPOINT/sender/addItem"),
  //       headers: {
  //         "Content-Type": "application/json; charset=utf-8",
  //       },
  //       body: body, // ส่งข้อมูลใน body
  //     );

  //     if (res.statusCode == 201) {
  //       final dataItem = jsonDecode(res.body); // แปลง JSON เป็น Map

  //       // ตรวจสอบว่ามีการส่งกลับ order_id หรือไม่
  //       if (dataItem.containsKey('order_id')) {
  //         // แสดงผล order_id หรือข้อมูลที่คุณต้องการใช้
  //         log('Item added with order ID: ${dataItem['order_id']}');
  //         // หากคุณต้องการเก็บข้อมูล item ใหม่ใน getAdd_item
  //         setState(() {
  //           getAdd_item.add(GetAddItemRes.fromJson(dataItem));
  //         });
  //       } else {
  //         log('No order_id found in response');
  //       }
  //     } else {
  //       log('Error creating order: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Error: $e');
  //   }
  // }
  void AddItem() async {
  if (getOrder_id == null) {
    log('Order ID is null');
    return; // ออกจากฟังก์ชันถ้าหาก order_id เป็น null
  }
  
  String? order_id = getOrder_id;
  String detail = detailNoCtl.text.trim();
  if (_imageUrl == null) {
    const SnackBar(content: Text('เลือกสักรูปสิ 🤔.'));
    return; // ออกจากฟังก์ชันหากไม่ได้เลือกภาพ
  }

  log('order_id: $order_id');
  log('detail: $detail');
  log('Image URL: $_imageUrl');

  try {
    // อ้างอิงไปยัง collection "OrderItem"
    CollectionReference orderItemCollection =
        FirebaseFirestore.instance.collection('OrderItem');

    // สร้างข้อมูลที่ต้องการบันทึกในรูปแบบของ Map
    Map<String, dynamic> itemData = {
      //'order_id': order_id, // ไม่จำเป็นต้องเก็บ order_id ที่นี่
      'detail': detail,
      'image': _imageUrl,
      //'timestamp': FieldValue.serverTimestamp(), // บันทึกเวลาสร้าง
    };

    // บันทึกข้อมูลไอเท็มลง Firestore
    DocumentReference itemDocRef = await orderItemCollection.add(itemData);
    log('Item added with ID: ${itemDocRef.id}');

    // อ้างอิงไปยังเอกสารใน Orders
    DocumentReference orderDocRef = FirebaseFirestore.instance
        .collection('Orders')
        .doc(order_id);

    // ดึงข้อมูลของเอกสาร Orders
    DocumentSnapshot orderDocSnapshot = await orderDocRef.get();

    // ตรวจสอบว่า array items มีข้อมูลหรือไม่
    if (orderDocSnapshot.exists) {
      List<dynamic> items = orderDocSnapshot['items'] ?? []; // ดึงข้อมูล items หรือใช้ array ว่างถ้าไม่มี

      if (items.isEmpty) {
        // หากไม่มีไอเท็มใน array ให้เพิ่มไอเท็มใหม่
        await orderDocRef.update({
          'items': [itemData], // สร้าง array ใหม่ที่มีไอเท็ม
        });
      } else {
        // หากมีไอเท็มอยู่แล้ว ให้เพิ่มไอเท็มใหม่ลงไปใน array
        await orderDocRef.update({
          'items': FieldValue.arrayUnion([itemData]), // เพิ่มไอเท็มใหม่ใน array
        });
      }
    }

    // ดึงข้อมูลของเอกสารที่เพิ่งแอดไป
    DocumentSnapshot newItem = await itemDocRef.get();

    // แปลงข้อมูลจาก Firestore เป็น Object ที่ใช้
    if (newItem.exists) {
      setState(() {
        getAdd_item.add(GetAddItemRes(
          order_id: newItem.id, // ใช้ document ID ของ order
          detail: detail, // ใช้ detail ที่กรอก
          image: _imageUrl,
          id: itemDocRef.id, // ID ของเอกสารที่บันทึกใน Firestore
        ));
      });
      log('New item data: ${newItem.data()}');
    } else {
      log('Newly added item not found');
    }
  } catch (e) {
    log('Error: $e');
  }
}


}
