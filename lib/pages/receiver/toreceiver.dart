import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/receiver/mapReceiver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class toReceiverPage extends StatefulWidget {
  const toReceiverPage({super.key});

  @override
  State<toReceiverPage> createState() => _toReceiverPageState();
}

class _toReceiverPageState extends State<toReceiverPage> {
  late UserProfile user;
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
          .where('receiver_id', isEqualTo: senderId)
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
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ordersJson.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersJson.length,
              itemBuilder: (context, index) {
                final order = ordersJson[index];
                final orderDetails = order['order_details'];
                final receiverInfo = order['receiver_info'].first;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      // Header displaying receiver's image and details
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(receiverInfo['image']),
                              radius: 25,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    receiverInfo['name'], // Receiver name
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(receiverInfo['phone']), // Receiver phone
                                  const SizedBox(height: 4),
                                  Text(
                                    'สถานะ: ${orderDetails['status_history'].last['status']}', // Status
                                    style: const TextStyle(color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Order details
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: List.generate(orderDetails['items'].length, (itemIndex) {
                            final item = orderDetails['items'][itemIndex];
                            return Row(
                              children: [
                                // Product image
                                Image.network(
                                  item['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 12),
                                // Product detail
                                Expanded(
                                  child: Text(
                                    item['detail'], // Product detail
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      // Status button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange[400],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Add functionality when button is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const mapReceiverPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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