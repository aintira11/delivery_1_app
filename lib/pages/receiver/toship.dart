import 'package:flutter/material.dart';

class ToShipPage extends StatefulWidget {
  const ToShipPage({super.key});

  @override
  State<ToShipPage> createState() => _ToShipPageState();
}

class _ToShipPageState extends State<ToShipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text to show the number of items
            const Text(
              'All 2',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Receiver 1
            Card(
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
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปของผู้ส่ง
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://play-lh.googleusercontent.com/7oW_TFaC5yllHJK8nhxHLQRCvGDE8jYIAc2SWljYpR6hQlFTkbA6lNvER1ZK-doQnQ=w240-h480-rw'),
                          radius: 30,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'jongwon',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text('0987456321'),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // รูปสินค้า
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Erdbeeren-WJP-1.jpg/360px-Erdbeeren-WJP-1.jpg',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),

                            // รายละเอียดสินค้า
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'สตรอเบอรี่',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'จำนวน: 2 กล่อง',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // รูปสินค้า
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Erdbeeren-WJP-1.jpg/360px-Erdbeeren-WJP-1.jpg',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 12),

                              // รายละเอียดสินค้า
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สตรอเบอรี่',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'จำนวน: 2 กล่อง',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),

                  // สถานะของคำสั่งซื้อ (อยู่ด้านล่างสุดของการ์ด)
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
                    child: const Text(
                      'สถานะ : รอไรเดอร์มารับสินค้า',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
