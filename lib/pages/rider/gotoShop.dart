import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/rider/homeRider.dart';
import 'package:delivery_1_app/pages/rider/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class GotoShopPage extends StatefulWidget {
  final User sender;
  final User receiver;
  final OrderData dataOrder;

  const GotoShopPage({
    super.key,
    required this.sender,
    required this.receiver,
    required this.dataOrder,
  });

  @override
  State<GotoShopPage> createState() => _GotoShopPageState();
}

class _GotoShopPageState extends State<GotoShopPage> {
  late LatLng senderLatLng;
  late LatLng receiverLatLng;
  LatLng? riderLatLng;
  double currentZoom = 16.0;
  late RiderProfile rider;
  var db = FirebaseFirestore.instance;
  MapController mapController = MapController();
  // สร้างตัวแปร orders เพื่อเก็บข้อมูลที่ดึงมาจาก Firebase
List<OrderData> orders = []; // สร้างตัวแปรให้เก็บเป็น List ของ OrderData

@override
void initState() {
  super.initState();
  
  rider = context.read<AppData>().rider;
  senderLatLng = LatLng(widget.sender.latitude, widget.sender.longitude);
  receiverLatLng = LatLng(widget.receiver.latitude, widget.receiver.longitude);
   // อัปเดตสถานะของออร์เดอร์
   updateOrderStatus(widget.dataOrder.id, rider.id);

  // เพิ่มข้อมูลไรเดอร์จ๊อบพร้อมกับตำแหน่งปัจจุบันของไรเดอร์
  if (riderLatLng != null) {
     addRiderJob(rider.id, widget.dataOrder.id, riderLatLng!);
  }

  _determineRiderPosition(); // ตรวจสอบตำแหน่งของไรเดอร์ครั้งแรก

  // เรียกใช้การอัปเดตข้อมูลออร์เดอร์และเพิ่มข้อมูล RiderJob
  _initializeOrderAndRiderJob();

  // ฟังการเปลี่ยนแปลงตำแหน่งของไรเดอร์แบบเรียลไทม์
  //_listenToRiderPositionChanges(); 
}

Future<void> _initializeOrderAndRiderJob() async {
  final riderId = context.read<AppData>().rider.id; // ไอดีไรเดอร์
  final orderId = widget.dataOrder.id; // ไอดีออร์เดอร์

  // อัปเดตสถานะของออร์เดอร์
  await updateOrderStatus(orderId, riderId);

  // เพิ่มข้อมูลไรเดอร์จ๊อบพร้อมกับตำแหน่งปัจจุบันของไรเดอร์
  if (riderLatLng != null) {
    await addRiderJob(riderId, orderId, riderLatLng!);
  }
}

  Future<void> _determineRiderPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      riderLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  // ฟังก์ชันสำหรับฟังตำแหน่งแบบเรียลไทม์
// void _listenToRiderPositionChanges() {
//   Geolocator.getPositionStream(
//     locationSettings: const LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 5, // อัปเดตเมื่อไรเดอร์เคลื่อนที่อย่างน้อย 5 เมตร
//     ),
//   ).listen((Position position) {
//     setState(() {
//       riderLatLng = LatLng(position.latitude, position.longitude);
//     });

//     if (riderLatLng != null) {
//       mapController.move(riderLatLng!, currentZoom);
//       addRiderJob(context.read<AppData>().rider.id, widget.dataOrder.id, riderLatLng!); // อัปเดตตำแหน่งใน RiderJob collection
//     }
//   });
// }
 
Future<void> updateOrderStatus(String orderId, String riderId) async {
  final orderRef = FirebaseFirestore.instance.collection('Orders').doc(orderId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(orderRef);
    
    if (!snapshot.exists) {
      throw Exception("คำสั่งไม่พบ!");
    }

    // ดึงสถานะประวัติปัจจุบัน
    List<dynamic> statusHistory = snapshot.data()!['status_history'];

    // แก้ไขสถานะล่าสุดในประวัติ
    if (statusHistory.isNotEmpty) {
      statusHistory[statusHistory.length - 1] = {
        'status': 'ไรด์เดอร์รับสินค้าแล้ว',
        // 'timestamp': FieldValue.serverTimestamp(), // ยกเลิกการคอมเมนต์เพื่อเพิ่ม timestamp
      };
    }

    // อัปเดต rider_id และ status_history
    transaction.update(orderRef, {
      'rider_id': riderId,
      'status_history': statusHistory,
    });
    
    log("อัปเดตคำสั่งสำเร็จ");
  }).catchError((error) {
    log("อัปเดตคำสั่งล้มเหลว: $error");
  });
}




Future<void> addRiderJob(String riderId, String orderId, LatLng riderPosition) async {
  CollectionReference riderJobData = FirebaseFirestore.instance.collection('RiderJob');
   await riderJobData.add({
    'rider_id': riderId,
    'order_id': orderId,
    'latitude': riderPosition.latitude,
    'longitude': riderPosition.longitude,
    'status': 'ไรด์เดอร์รับงานแล้ว',
    'timestamp': FieldValue.serverTimestamp(),
   });
    log("เพิ่ม job สำเร็จ");
}

// เมื่อไรด์เดอร์กดรับงาน
// void onAcceptJob(String orderId) {
//   final riderId = context.read<AppData>().rider.id; // รับ rider ID
//   final LatLng riderPosition = LatLng(riderLatLng!.latitude, riderLatLng!.longitude); // ตำแหน่งของไรเดอร์

//   updateOrderStatus(orderId, riderId); // อัปเดตสถานะใน Orders collection
//   addRiderJob(riderId, orderId, riderPosition); // เพิ่มข้อมูลใน RiderJob collection
// }


// void startRealtimeGet() async {
//   try {
//     final ordersRef = db.collection("Orders");
//     final snapshot = await ordersRef.get();
//     List<OrderData> fetchedOrders = []; // ตัวแปรชั่วคราวเพื่อเก็บคำสั่งซื้อที่ดึงมา

//     for (var doc in snapshot.docs) {
//       var data = doc.data();
//       if (data['status_history'] != null && data['status_history'].isNotEmpty) {
//         for (var status in data['status_history']) {
//           if (status['status'] == "รอไรด์เดอร์") {
//             OrderData order = OrderData.fromMap(doc.id, data);

//             // ดึงข้อมูลผู้ใช้จาก receiver_id และ sender_id
//             String receiverId = data['receiver_id'];
//             String senderId = data['sender_id'];

//             // ดึงข้อมูลผู้รับ
//             var receiverDoc = await db.collection("Users").doc(receiverId).get();
//             if (receiverDoc.exists) {
//               var receiverData = receiverDoc.data();
//               order.receiver = User.fromMap(receiverData!); // เก็บข้อมูลผู้รับ
//             } else {
//               log("No receiver found for ID: $receiverId");
//             }

//             // ดึงข้อมูลผู้ส่ง
//             var senderDoc = await db.collection("Users").doc(senderId).get();
//             if (senderDoc.exists) {
//               var senderData = senderDoc.data();
//               order.sender = User.fromMap(senderData!); // เก็บข้อมูลผู้ส่ง
//             } else {
//               log("No sender found for ID: $senderId");
//             }

//             fetchedOrders.add(order); // เพิ่ม OrderData ที่ดึงมาเข้าไปใน List
//             break; // หยุด loop เมื่อเจอสถานะที่ต้องการ
//           }
//         }
//       }
//     }

//     setState(() {
//       orders = fetchedOrders; // อัปเดต orders ให้มีค่าที่ดึงมา
//     });
//   } catch (error) {
//     log("Fetch failed: $error");
//   }
// }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go to shop'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RiderHomePage(),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: riderLatLng ?? senderLatLng,
              initialZoom: currentZoom,
              onMapReady: () {
                if (riderLatLng != null) {
                  mapController.move(riderLatLng!, currentZoom);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                maxNativeZoom: 16,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: senderLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  Marker(
                    point: receiverLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  if (riderLatLng != null)
                    Marker(
                      point: riderLatLng!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.directions_bike,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.4,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 176, 50),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                     Text(
                      'Location Details : ${widget.dataOrder.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Sender Location', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Text(
                      'ตำแหน่ง : ${widget.sender.address}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text('Receiver Location',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Text(
                      'ตำแหน่ง : ${widget.receiver.address}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => orderRiderPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green[300], // Green confirm button
                                minimumSize:
                                    Size(double.infinity, 50), // Button width
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Pick up ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}