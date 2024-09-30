import 'package:delivery_1_app/pages/sender/mapSender.dart';
import 'package:flutter/material.dart';

class CheckStatusPage extends StatefulWidget {
  const CheckStatusPage({super.key});

  @override
  State<CheckStatusPage> createState() => _CheckStatusPageState();
}

class _CheckStatusPageState extends State<CheckStatusPage> {
  // ตัวอย่างข้อมูล JSON จำลอง
  final List<Map<String, dynamic>> ordersJson = [
    {
      "name": "Lananima",
      "phone": "0987456321",
      "status": "ไรเดอร์รับงานแล้ว",
      "imageUrls": [
        "https://api2.krua.co/wp-content/uploads/2022/05/RT1719_ImageBanner_1140x507-4.jpg"
      ],
      "orderDetails": [
        {"item": "ไข่พะโล้พี่เอ๋อ"}
      ]
    },
    {
      "name": "Shino",
      "phone": "0555555555",
      "status": "ไรเดอร์รับงานแล้ว",
      "imageUrls": [
        "https://api2.krua.co/wp-content/uploads/2022/05/RT1719_ImageBanner_1140x507-4.jpg",
        "https://api2.krua.co/wp-content/uploads/2022/05/RT1719_ImageBanner_1140x507-4.jpg"
      ],
      "orderDetails": [
        {"item": "ไก่ย่าง"},
        {"item": "ส้มตำ"}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Status'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: ordersJson.length,
          itemBuilder: (context, index) {
            final order = ordersJson[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OrderCard(
                name: order["name"],
                phone: order["phone"],
                status: order["status"],
                imageUrls: List<String>.from(order["imageUrls"]),
                orderDetails: List<Map<String, dynamic>>.from(
                    order["orderDetails"]), // Ensure correct type
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String name;
  final String phone;
  final String status;
  final List<String> imageUrls;
  final List<Map<String, dynamic>>
      orderDetails; // Keep this as List<Map<String, dynamic>>

  const OrderCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.status,
    required this.imageUrls,
    required this.orderDetails,
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
            // แถวแรก: ชื่อและสถานะ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name: $name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'สถานะ: $status',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8.0),
            // เบอร์โทร
            Text('Phone: $phone'),
            const SizedBox(height: 8.0),
            const Divider(color: Colors.black),
            // แถวที่สอง: รูปภาพสินค้า และเนื้อหา order
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // จัดให้เนื้อหาอยู่ในระดับบนสุด
                children: [
                  // รูปภาพในแนวนอน
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: imageUrls.map((url) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            url,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                      width: 16.0), // ระยะห่างระหว่างรูปภาพและเนื้อหา order

                  // ข้อมูล order เรียงเป็นแนวตั้ง
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
                        // แสดงรายละเอียดการสั่งซื้อ
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: orderDetails
                              .map((detail) => Text(detail[
                                  "item"])) // ใช้ map เพื่อแสดงชื่อรายการ
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8.0),
            // ปุ่ม Status
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MapSenderPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                   minimumSize: Size(double.infinity, 40),
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )
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
