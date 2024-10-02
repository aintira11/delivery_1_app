import 'package:delivery_1_app/pages/receiver/mapReceiver.dart';
import 'package:flutter/material.dart';

class toReceiverPage extends StatefulWidget {
  const toReceiverPage({super.key});

  @override
  State<toReceiverPage> createState() => _toReceiverPageState();
}

class _toReceiverPageState extends State<toReceiverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Status'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // สีไอคอน back และชื่อ AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Column(
                children: [
                  // หัวการ์ดแสดงรูปและรายละเอียดของผู้รับ
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[100], // สีพื้นหลังหัวการ์ด
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://i.imgur.com/BoN9kdC.png', // รูปผู้รับ
                          ),
                          radius: 25,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lananima', // ชื่อผู้รับ
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text('0987456321'),
                              SizedBox(height: 4),
                              Text(
                                'สถานะ : ไรเดอร์รับงานแล้ว', // สถานะการส่ง
                                style: TextStyle(color: Colors.orange),
                              ), // เบอร์โทรผู้รับ
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // รายละเอียดออร์เดอร์
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // รูปสินค้า
                        Image.network(
                          'https://i.ytimg.com/vi/QqvRJ1XbUf0/maxresdefault.jpg', // รูปสินค้า
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12),
                        // ชื่อสินค้า
                        const Expanded(
                          child: Text(
                            'ไข่พะโล้พี่เอ', // ชื่อสินค้า
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ปุ่มแสดงสถานะ
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
                        // เพิ่มการทำงานเมื่อปุ่มถูกกด
                         Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const mapReceiverPage()),
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
            ),
          ],
        ),
      ),
    );
  }
}
