import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/sender/mapSender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckStatusPage extends StatefulWidget {
  const CheckStatusPage({super.key});

  @override
  State<CheckStatusPage> createState() => _CheckStatusPageState();
}

class _CheckStatusPageState extends State<CheckStatusPage> {
  late UserProfile user;

  // List to store orders in JSON format
  List<Map<String, dynamic>> ordersJson = [];

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    fetchOrders(user.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchOrders(user.id);
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

        // Check if status_history is a List and find the status 'ไรด์เดอร์รับสินค้าแล้ว'
        if (orderData['status_history'] is List) {
          final statusHistory = orderData['status_history'] as List<dynamic>;

          // Get the latest status from status_history
          final latestStatus =
              statusHistory.isNotEmpty ? statusHistory.last['status'] : '';

          // Skip if the latest status is not 'ไรด์เดอร์รับสินค้าแล้ว'
          if (latestStatus != 'ไรด์เดอร์รับสินค้าแล้ว') {
            continue;
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
          'order_details': orderData,
          'receiver_info': userDataList,
        };

        tempOrdersList.add(orderWithUser);
      }

      setState(() {
        ordersJson = tempOrdersList;
      });

      // Log the orders in JSON format
      String jsonResult = jsonEncode(ordersJson);
      log(jsonResult);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Status'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ordersJson.isNotEmpty
            ? ListView.builder(
                itemCount: ordersJson.length,
                itemBuilder: (context, index) {
                  final order = ordersJson[index];
                  final orderDetails = order["order_details"];
                  final items = orderDetails['items'] as List<dynamic>;
                  final imageUrlList = items
                      .map((item) => item['image'])
                      .toList()
                      .cast<String>();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: OrderCard(
                      orderNumber: order['order_id'],
                      name: order["receiver_info"][0]["name"],
                      phone: order["receiver_info"][0]["phone"],
                      address: order["receiver_info"][0]["address"],
                      imageUrl: imageUrlList.isNotEmpty ? imageUrlList[0] : '',
                      items: items
                          .map((item) => item as Map<String, dynamic>)
                          .toList(),
                      status: orderDetails['current_status'] ?? 'รอการอัพเดท',
                      statusHistory: orderDetails['status_history']
                          as List<dynamic>?, // Pass the status_history
                    ),
                  );
                },
              )
            : const Center(
                child: Text('ไม่มีคำสั่งซื้อในขณะนี้'),
              ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String name;
  final String phone;
  final String address;
  final String imageUrl;
  final List<Map<String, dynamic>> items;
  final String status;
  final List<dynamic>? statusHistory;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.name,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.items,
    required this.status,
    this.statusHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #: $orderNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text('Name: $name'),
            Text('📞: $phone'),
            Text('🏠 : $address'),
            const SizedBox(height: 8.0),
            const Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items.map((item) {
                      final imageUrl = item['image'] ?? '';
                      final detail = item['detail'] ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                imageUrl,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                detail,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Display all statuses from statusHistory
            const Text(
              'สถานะ:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            const SizedBox(height: 8.0),
            statusHistory != null && statusHistory!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: statusHistory!.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '${statusHistory![index]['status']}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  )
                : const Text(
                    'ไม่มีสถานะ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 8.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapSenderPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
