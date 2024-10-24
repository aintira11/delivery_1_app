import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/login.dart';
import 'package:delivery_1_app/pages/rider/gotoShop.dart';
import 'package:delivery_1_app/pages/rider/order.dart';
import 'package:delivery_1_app/pages/rider/position.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  var docCtl = TextEditingController();
  late RiderProfile rider;
  var db = FirebaseFirestore.instance;
  List<OrderData> orders = []; // ตัวแปรเก็บข้อมูลคำสั่งซื้อ
  List<User> user = [];
  //StreamSubscription? listener;

  @override
  void initState() {
    super.initState();
    rider = context.read<AppData>().rider;
    startRealtimeGet();
    //listenForOrderUpdates();
  }

  @override
  Widget build(BuildContext context) {
    //docCtl.text ='ZMSf0GsdaMAieIzSwXv4';
    return Consumer<AppData>(builder: (context, appData, child) {
      final rider = appData.rider;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(rider.image), // รูปภาพผู้ใช้
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name : ${rider.name}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        'Phone : ${rider.phone}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  // เคลียร์ข้อมูลผู้ใช้
                  Provider.of<AppData>(context, listen: false).clearUser();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Job',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${rider.vehicle}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a job',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ...orders.map((order) {
              // สร้าง Widget สำหรับการแสดงข้อมูลคำสั่งซื้อ
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order.id}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // ใช้ Expanded เพื่อให้ Sender และ Sent to ยืดหยุ่น
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sender',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Name : ${order.sender.name}'),
                              Text('📞 : ${order.sender.phone}'),
                              Text(
                                  '🏠 : ${order.sender.address}'), // แสดงข้อมูลผู้ส่ง
                              // คุณอาจจะต้องดึงข้อมูลผู้ส่งจาก Firestore
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 20),
                        Expanded(
                          // ใช้ Expanded เพื่อให้ Sender และ Sent to ยืดหยุ่น
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sent to',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Name : ${order.receiver.name}'),
                              Text('📞 : ${order.receiver.phone}'),
                              Text(
                                  '🏠 : ${order.receiver.address}'), // แสดงข้อมูลผู้รับ
                              // คุณอาจจะต้องดึงข้อมูลผู้รับจาก Firestore
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Column(
                      children: [
                        const Text('Order',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        for (var item in order.items) // แสดงรายการสินค้า
                          Row(
                            children: [
                              Image.network(item.image,
                                  width: 50, height: 50, fit: BoxFit.cover),
                              const SizedBox(width: 10),
                              Expanded(
                                // ใช้ Expanded เพื่อให้ข้อความยืดหยุ่น
                                child: Text(item.detail,
                                    overflow: TextOverflow
                                        .ellipsis), // เพิ่ม overflow
                              ),
                            ],
                          
                          ),
                          
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => positionPage(
                                          sender:
                                              order.sender, // ส่งข้อมูลผู้ส่ง
                                          receiver:
                                              order.receiver, // ส่งข้อมูลผู้รับ
                                        )));
                          },
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text('ดูตำแหน่ง'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showConfirmationDialog(order.id, order);
                          },
                          child: const Text('รับงานนี้'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  void startRealtimeGet() async {
    try {
      final ordersRef = db.collection("Orders");
      final snapshot = await ordersRef.get();
      List<OrderData> ordersList = []; // รายการคำสั่งที่ดึงมา

      log("Total documents fetched: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        var data = doc.data();

        if (data['status_history'] != null &&
            data['status_history'].isNotEmpty) {
          for (var status in data['status_history']) {
            if (status['status'] == "รอไรด์เดอร์") {
              // สร้าง OrderData โดยส่ง ID เอกสารเข้าไป
              OrderData order = OrderData.fromMap(doc.id, data);

              // ดึงข้อมูลผู้ใช้จาก receiver_id และ sender_id
              String receiverId = data['receiver_id'];
              String senderId = data['sender_id'];

              // ดึงข้อมูลผู้รับ
              var receiverDoc =
                  await db.collection("Users").doc(receiverId).get();
              if (receiverDoc.exists) {
                var receiverData = receiverDoc.data();
                order.receiver =
                    User.fromMap(receiverData!); // เก็บข้อมูลผู้รับ
              } else {
                log("No receiver found for ID: $receiverId");
              }

              // ดึงข้อมูลผู้ส่ง
              var senderDoc = await db.collection("Users").doc(senderId).get();
              if (senderDoc.exists) {
                var senderData = senderDoc.data();
                order.sender = User.fromMap(senderData!); // เก็บข้อมูลผู้ส่ง
              } else {
                log("No sender found for ID: $senderId");
              }

              ordersList.add(order); // เพิ่ม OrderData ตามที่ต้องการ
              log("Order ID: ${doc.id} - Current Status: ${status['status']}");
              log("Data Order: ${order}"); // log ข้อมูลของ OrderData ที่เจอ
              break; // หยุด loop เมื่อเจอสถานะที่ต้องการ
            }
          }
        } else {
          log("No status_history found for Document ID: ${doc.id}");
        }
      }

      setState(() {
        orders = ordersList; // อัปเดตสถานะคำสั่ง
        log('data order all ${orders}');
      });

      // แสดง Snackbar หรือข้อมูลที่ได้
      if (orders.isNotEmpty) {
        Get.snackbar("New Orders Available", "${orders.length} orders found");
      } else {
        Get.snackbar(
            "No Orders", "No orders available with status 'รอไรด์เดอร์'");
      }
    } catch (error) {
      log("Fetch failed: $error");
    }
  }

  // ฟังก์ชันสำหรับฟังการเปลี่ยนแปลงแบบเรียลไทม์
  void listenForOrderUpdates() {
    try {
      final ordersRef = db.collection("Orders");

      // ใช้ snapshots() แทน get()
      ordersRef.snapshots().listen((snapshot) {
        List<OrderData> ordersList = []; // รายการคำสั่งที่ดึงมา

        log("Total documents fetched: ${snapshot.docs.length}");

        for (var doc in snapshot.docs) {
          var data = doc.data();

          if (data['status_history'] != null &&
              data['status_history'].isNotEmpty) {
            for (var status in data['status_history']) {
              if (status['status'] == "รอไรด์เดอร์") {
                // ดึงข้อมูลผู้ใช้จาก receiver_id และ sender_id
                String receiverId = data['receiver_id'];
                String senderId = data['sender_id'];

                // สร้าง OrderData เริ่มต้น
                OrderData order = OrderData.fromMap(doc.id, data);

                // ดึงข้อมูลผู้รับ
                db
                    .collection("Users")
                    .doc(receiverId)
                    .snapshots()
                    .listen((receiverDoc) {
                  if (receiverDoc.exists) {
                    var receiverData = receiverDoc.data();
                    order.receiver =
                        User.fromMap(receiverData!); // เก็บข้อมูลผู้รับ
                  } else {
                    log("No receiver found for ID: $receiverId");
                  }
                });

                // ดึงข้อมูลผู้ส่ง
                db
                    .collection("Users")
                    .doc(senderId)
                    .snapshots()
                    .listen((senderDoc) {
                  if (senderDoc.exists) {
                    var senderData = senderDoc.data();
                    order.sender =
                        User.fromMap(senderData!); // เก็บข้อมูลผู้ส่ง
                  } else {
                    log("No sender found for ID: $senderId");
                  }
                });

                ordersList.add(order); // เพิ่ม OrderData ตามที่ต้องการ
                log("Order ID: ${doc.id} - Current Status: ${status['status']}");
                log("Data Order: ${order}"); // log ข้อมูลของ OrderData ที่เจอ
                break; // หยุด loop เมื่อเจอสถานะที่ต้องการ
              }
            }
          } else {
            log("No status_history found for Document ID: ${doc.id}");
          }
        }

        setState(() {
          orders = ordersList; // อัปเดตสถานะคำสั่ง
          log('data order all ${orders}');
        });

        // แสดง Snackbar หรือข้อมูลที่ได้
        if (orders.isNotEmpty) {
          Get.snackbar("New Orders Available", "${orders.length} orders found");
        } else {
          Get.snackbar(
              "No Orders", "No orders available with status 'รอไรด์เดอร์'");
        }
      });
    } catch (error) {
      log("Fetch failed: $error");
    }
  }

  void stopRealTime() {
    if (context.read<AppData>().listener != null) {
      context.read<AppData>().listener!.cancel();
      context.read<AppData>().listener = null;
      log('listener stopped');
    }
  }

  void showConfirmationDialog(String orderid, OrderData order) { // เปลี่ยนจาก dynamic order เป็น OrderData order
  log('orderid : ${orderid}');
  log('order : ${order}');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFA0E7A0),
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ยืนยันการรับงาน',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Image.asset(
                'assets/images/fast-delivery.png',
                height: 110,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Order number ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                orderid,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      stopRealTime();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GotoShopPage(
                            sender: order.sender, // ส่งข้อมูลผู้ส่ง
                            receiver: order.receiver, // ส่งข้อมูลผู้รับ
                             dataOrder: order
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}

// โมเดล OrderData
class OrderData {
  final String id; // เพิ่มฟิลด์ ID
  final List<Item> items;
  final String receiverId;
  final String senderId;
  final List<StatusHistory> statusHistory;
  late User sender;
  late User receiver;

  OrderData({
    required this.id, // เพิ่มพารามิเตอร์สำหรับ ID
    required this.items,
    required this.receiverId,
    required this.senderId,
    required this.statusHistory,
  });

  factory OrderData.fromMap(String id, Map<String, dynamic> data) {
    // รับ ID เป็นพารามิเตอร์
    var itemList =
        (data['items'] as List).map((item) => Item.fromMap(item)).toList();

    var statusHistoryList = (data['status_history'] as List)
        .map((status) => StatusHistory.fromMap(status))
        .toList();

    return OrderData(
      id: id, // เก็บ ID
      items: itemList,
      receiverId: data['receiver_id'],
      senderId: data['sender_id'],
      statusHistory: statusHistoryList,
    );
  }

  @override
  String toString() {
    return 'OrderData(id: $id, items: $items, receiverId: $receiverId, senderId: $senderId, statusHistory: $statusHistory, sender: $sender, receiver: $receiver)';
  }
}

// โมเดลสำหรับผู้ใช้ (User)
class User {
  final String name;
  final String phone;
  final String address;
  final String image; // เพิ่มฟิลด์สำหรับ URL ของภาพ
  final double latitude; // เพิ่มฟิลด์สำหรับ latitude
  final double longitude; // เพิ่มฟิลด์สำหรับ longitude
  final String password; // เพิ่มฟิลด์สำหรับ password
  final String type; // เพิ่มฟิลด์สำหรับ type

  User({
    required this.name,
    required this.phone,
    required this.address,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.password,
    required this.type,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['name'],
      phone: data['phone'],
      address: data['address'],
      image: data['image'], // เก็บ URL ของภาพ
      latitude: data['latitude'], // เก็บค่า latitude
      longitude: data['longitude'], // เก็บค่า longitude
      password: data['password'], // เก็บ password
      type: data['type'], // เก็บ type
    );
  }

  @override
  String toString() {
    return 'User(name: $name, phone: $phone, address: $address, image: $image, latitude: $latitude, longitude: $longitude, password: $password, type: $type)';
  }
}

// โมเดล Item และ StatusHistory ยังคงเหมือนเดิม
class Item {
  final String detail;
  final String image;

  Item({
    required this.detail,
    required this.image,
  });

  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      detail: data['detail'],
      image: data['image'],
    );
  }

  @override
  String toString() {
    return 'Item(detail: $detail, image: $image)';
  }
}

class StatusHistory {
  final String status;
  final String note;

  StatusHistory({
    required this.status,
    required this.note,
  });

  factory StatusHistory.fromMap(Map<String, dynamic> data) {
    return StatusHistory(
      status: data['status'],
      note: data['note'],
    );
  }

  @override
  String toString() {
    return 'StatusHistory(status: $status, note: $note)';
  }
}
