import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToShipPage extends StatefulWidget {
  const ToShipPage({super.key});

  @override
  State<ToShipPage> createState() => _ToShipPageState();
}

class _ToShipPageState extends State<ToShipPage> {
  late UserProfile user;
  List<Map<String, dynamic>> ordersList = [];

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    fetchOrders(user.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchOrders(user.id); // เรียกใช้งานทุกครั้งที่หน้าถูกดึงเข้ามาใหม่
  }

  Future<void> fetchOrders(String senderId) async {
    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('receiver_id', isEqualTo: senderId)
          .get();

      List<Map<String, dynamic>> tempOrdersList = [];
      for (var orderDoc in ordersSnapshot.docs) {
        Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

        // ตรวจสอบว่า status_history เป็น List และหาสถานะ 'รอไรด์เดอร์'
        if (orderData['status_history'] is List) {
          final statusHistory = orderData['status_history'] as List<dynamic>;

          // ดึงสถานะล่าสุดจาก status_history
          final latestStatus = statusHistory.isNotEmpty
              ? statusHistory.last['status'] // เอาสถานะล่าสุดจากตัวสุดท้ายของอาร์เรย์
              : '';

          // หากสถานะล่าสุดไม่ใช่ 'รอไรด์เดอร์' ให้ข้าม
          if (latestStatus != 'รอไรด์เดอร์') {
            continue; // ข้ามคำสั่งนี้ถ้าไม่ใช่สถานะ 'รอไรด์เดอร์'
          }

          // แปลง timestamp เป็น String
          for (var status in statusHistory) {
            if (status['timestamp'] is Timestamp) {
              status['timestamp'] =
                  (status['timestamp'] as Timestamp).toDate().toIso8601String();
            }
          }
        }

        String receiverId = orderData['receiver_id'];
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(receiverId)
            .get();

        List<Map<String, dynamic>> userDataList = [];
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          userDataList.add(userData);
        }

        Map<String, dynamic> orderWithUser = {
          'order_id': orderDoc.id,
          'order_details': {
            'receiver_id': orderData['receiver_id'],
            'status_history': orderData['status_history'],
            'current_status': orderData['current_status'],
            'image_url_1': orderData['image_url_1'],
            'items': orderData['items'],
          },
          'receiver_info': userDataList,
        };

        tempOrdersList.add(orderWithUser);
      }

      setState(() {
        ordersList = tempOrdersList; // อัปเดตตัวแปร
      });

      // แสดงข้อมูลออกมาในรูปแบบ JSON
      String jsonResult = jsonEncode(ordersList);
      log(jsonResult);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: ordersList.length, // Corrected to use ordersList
          itemBuilder: (context, index) {
            final order = ordersList[index]; // Use ordersList
            final orderDetails = order['order_details'];
            final receiverInfo = order['receiver_info'][0];
            final items = orderDetails['items'];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวการ์ดที่มีรูปและรายละเอียดของผู้รับ
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // สีพื้นหลังหัวการ์ด
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปของผู้รับ
                        CircleAvatar(
                          backgroundImage: NetworkImage(receiverInfo['image']),
                          radius: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receiverInfo['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(receiverInfo['phone']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),

                  // รายการสินค้า
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'รายการที่จะได้รับ:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: items.map<Widget>((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // รูปสินค้า
                                Image.network(
                                  item['image'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 12),
                                // รายละเอียดสินค้า
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['detail'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // สถานะของคำสั่งซื้อ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[50], // สีพื้นหลังสถานะ
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'สถานะ: ${orderDetails['current_status'] ?? orderDetails['status_history'][0]['status']}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
