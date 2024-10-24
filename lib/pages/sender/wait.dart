import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitRiderPage extends StatefulWidget {
  const WaitRiderPage({super.key});

  @override
  State<WaitRiderPage> createState() => _WaitRiderPageState();
}

class _WaitRiderPageState extends State<WaitRiderPage> {
  late UserProfile user;
  late Future<void> loadData;
  List<Map<String, dynamic>> ordersList = []; // เพิ่มตัวแปรนี้
  //List<DataSenderWaitRes> data = [];

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
          .where('sender_id', isEqualTo: senderId)
          .get();

      List<Map<String, dynamic>> tempOrdersList = [];
      for (var orderDoc in ordersSnapshot.docs) {
        Map<String, dynamic> orderData =
            orderDoc.data() as Map<String, dynamic>;

        // ตรวจสอบว่า status_history เป็น List และหาสถานะ 'รอไรด์เดอร์'
        if (orderData['status_history'] is List) {
          final statusHistory = orderData['status_history'] as List<dynamic>;

          // ดึงสถานะล่าสุดจาก status_history
          final latestStatus = statusHistory.isNotEmpty
              ? statusHistory
                  .last['status'] // เอาสถานะล่าสุดจากตัวสุดท้ายของอาร์เรย์
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
      appBar: AppBar(title: const Text('Wait Rider')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          final order = ordersList[index];
          final receiverInfo = order['receiver_info'].isNotEmpty
              ? order['receiver_info'][0]
              : {};
          final items = order['order_details']['items'] as List<dynamic>;

          // ดึงสถานะล่าสุดจาก status_history
          final statusHistory =
              order['order_details']['status_history'] as List<dynamic>;
          final latestStatus = statusHistory.isNotEmpty
              ? statusHistory
                  .last['status'] // เอาสถานะล่าสุดจากตัวสุดท้ายของอาร์เรย์
              : 'Unknown';

          return OrderCard(
            orderNumber: order['order_id'],
            name: receiverInfo['name'] ?? 'Unknown',
            phone: receiverInfo['phone'] ?? 'Unknown',
            imageUrl: order['order_details']['status_history'].isNotEmpty
                ? order['order_details']['status_history'][0]['image_url_1'] ??
                    ''
                : '', // ส่ง image_url_1
            items: items
                .map((e) => e as Map<String, dynamic>)
                .toList(), // ส่ง items เป็น List<Map<String, dynamic>>
            status: latestStatus, // ใช้สถานะล่าสุดที่ดึงมา
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String name;
  final String phone;
  final String imageUrl;
  final List<Map<String, dynamic>> items;
  final String status;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.items,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Number: $orderNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Name: $name'),
                Text('📞: $phone'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.image_not_supported),
                          ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(item['detail']),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'สถานะ: $status',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
