import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/login.dart';
import 'package:delivery_1_app/pages/rider/order.dart';
import 'package:delivery_1_app/pages/rider/position.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  late RiderProfile rider;
  @override
  void initState() {
    super.initState();
    rider = context.read<AppData>().rider;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        final rider = appData.rider;
        return Consumer<AppData>(
          builder: (context, appData, child) {
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
                          backgroundImage:
                              NetworkImage(rider.riderImage), // รูปภาพผู้ใช้
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name : ${rider.riderName}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              'Phone : ${rider.riderPhone}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        // เคลียร์ข้อมูลผู้ใช้
                        Provider.of<AppData>(context, listen: false)
                            .clearUser();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage()), // เปลี่ยนเป็นหน้า Login ของคุณ
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Job',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${rider.vehicle}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select a job',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    JobCard(
                      orderNumber: 99,
                      senderName: 'Nanin',
                      senderPhone: '0957455574',
                      receiverName: 'Yoko',
                      receiverPhone: '0988884599',
                      orderNote: 'ส้มตำ ไก่ทอด',
                      distance: 20,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/delivery-app-1-9652b.appspot.com/o/product%2Fwait1.png?alt=media&token=4193e499-41f0-417e-aa09-64ef0048cb49',
                    ),
                    JobCard(
                      orderNumber: 95,
                      senderName: 'Nanin',
                      senderPhone: '0957455574',
                      receiverName: 'Yoko',
                      receiverPhone: '0988884599',
                      orderNote: 'นม ไข่',
                      distance: 23,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/delivery-app-1-9652b.appspot.com/o/product%2Fwait1.png?alt=media&token=4193e499-41f0-417e-aa09-64ef0048cb49',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class JobCard extends StatelessWidget {
  final int orderNumber;
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String orderNote;
  final int distance;
  final String imageUrl;

  JobCard({
    required this.orderNumber,
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.orderNote,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                imageUrl,
                height: 110,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Order Number $orderNumber',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sender',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Name : $senderName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Phone : $senderPhone',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sent to',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Name : $receiverName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Phone : $receiverPhone',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        orderNote,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // การทำงานเมื่อกดปุ่มดูตำแหน่ง
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const positionPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_pin),
                  label: Text('$distance Km'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(context, orderNumber);
                  },
                  child: Text('รับงาน'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, int orderNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // ปรับมุมให้กลมมากขึ้น
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFA0E7A0), // สีพื้นหลังของการ์ด
              borderRadius: BorderRadius.circular(30.0), // ปรับมุมให้กลมมากขึ้น
              border: Border.all(
                color: Colors.black, // สีของเส้นกรอบ
                width: 2.0, // ความหนาของเส้นกรอบ
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
                  'assets/images/fast-delivery.png', // ใส่ภาพไอคอนของคุณที่นี่
                  height: 110,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                //SizedBox(height: 20),

                const SizedBox(height: 10),
                Text(
                  'Order number $orderNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // การทำงานเมื่อกดปุ่มยืนยัน
                        //Navigator.of(context).pop(); // ปิด dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const orderRiderPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // สีพื้นหลังของปุ่มยืนยัน
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'ยืนยัน',
                        style: TextStyle(
                          color: Colors.black, // สีตัวหนังสือในปุ่มยืนยัน
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // การทำงานเมื่อกดปุ่มยกเลิก
                        Navigator.of(context).pop(); // ปิด dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.black, // สีพื้นหลังของปุ่มยกเลิก
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white, // สีตัวหนังสือในปุ่มยกเลิก
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
