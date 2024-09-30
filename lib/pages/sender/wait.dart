import 'package:flutter/material.dart';

class WaitRiderPage extends StatefulWidget {
  const WaitRiderPage({super.key});

  @override
  State<WaitRiderPage> createState() => _WaitRiderPageState();
}

class _WaitRiderPageState extends State<WaitRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wait Rider')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          OrderCard(
            orderNumber: '90',
            name: 'Yoko',
            phone: '0111111111',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/delivery-app-1-9652b.appspot.com/o/product%2Fwait1.png?alt=media&token=4193e499-41f0-417e-aa09-64ef0048cb49',
            orderDetails: 'สินค้า ไก่ย่าง',
            status: 'รอไรเดอร์มารับสินค้า',
          ),
          SizedBox(height: 16.0),
          OrderCard(
            orderNumber: '89',
            name: 'Mini',
            phone: '0111111881',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/delivery-app-1-9652b.appspot.com/o/product%2Fwait1.png?alt=media&token=4193e499-41f0-417e-aa09-64ef0048cb49',
            orderDetails: 'มาม่า',
            status: 'รอไรเดอร์มารับสินค้า',
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String name;
  final String phone;
  final String imageUrl;
  final String orderDetails;
  final String status;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.orderDetails,
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
          // ส่วนหัวของการ์ดพร้อมสีพื้นหลัง
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade100, // สีพื้นหลังของหัวการ์ด
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
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Name: $name'),
                Text('Phone: $phone'),
              ],
            ),
          ),
          // เนื้อหาหลักของการ์ด
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row สำหรับจัดเรียงรูปภาพและข้อมูล Order ให้อยู่ในแนวนอน
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // จัดให้เนื้อหาเรียงจากด้านบนสุด
                  children: [
                    // รูปภาพ
                    Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                        width: 16.0), // ระยะห่างระหว่างรูปภาพกับเนื้อหา

                    // คอลัมน์สำหรับข้อมูล Order
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(orderDetails), // เนื้อหาของ Order แสดงในแนวตั้ง
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
