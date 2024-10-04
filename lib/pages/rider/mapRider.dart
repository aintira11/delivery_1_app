import 'package:delivery_1_app/pages/rider/comfirmImageRider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class mapRiderPage extends StatefulWidget {
  const mapRiderPage({super.key});

  @override
  State<mapRiderPage> createState() => _mapRiderPageState();
}

class _mapRiderPageState extends State<mapRiderPage> {
  LatLng latLng1 =
      const LatLng(15.998009549056942, 102.53815639596311); // จุดแรก
  LatLng latLng2 = const LatLng(
      15.998509549056942, 102.53865639596311); // จุดที่สองใกล้ๆ กับจุดแรก
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ปิดการใช้งานปุ่มย้อนกลับ Return false
        //return false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Check Status'),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            // แผนที่
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: latLng1,
                initialZoom: 16.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    // Marker จุดแรก
                    Marker(
                      point: latLng1,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.motorcycle,
                        size: 30,
                        color: Colors.red,
                      ),
                      alignment: Alignment.center,
                    ),
                    // Marker จุดที่สอง
                    Marker(
                      point: latLng2,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.green,
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                // เส้นที่เชื่อมระหว่างสองจุด
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [latLng1, latLng2], // เส้นจาก latLng1 ไป latLng2
                      color: Colors.blue, // สีของเส้น
                      strokeWidth: 4.0, // ความกว้างของเส้น
                    ),
                  ],
                ),
              ],
            ),
            // แถบข้อมูลออเดอร์ด้านล่างที่สามารถเลื่อนขึ้น-ลงได้
            DraggableScrollableSheet(
              initialChildSize: 0.2, // ขนาดเริ่มต้นของแถบ
              minChildSize: 0.1, // ขนาดต่ำสุดของแถบ
              maxChildSize: 0.4, // ขนาดสูงสุดของแถบ
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(187, 240, 166, 55), // พื้นหลังสีส้มอ่อน
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20), // มุมโค้งด้านบน
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -2), // เงาด้านบนของแถบ
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ขีดตรงกลาง
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          children: [
                            const Text(
                              'Sent To',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text('Name: Shino'),
                            const Text('Phone: 0555555555'),
                            const Text('Address: 88/1 aaa kkk mkmk'),
                            const Divider(),
                            const Text(
                              'Order Number: 90',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.network(
                                  'https://api2.krua.co/wp-content/uploads/2022/05/RT1719_ImageBanner_1140x507-4.jpg',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 20),
                                const Text('ไก่ย่าง'),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageConfirmPage()),
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
                                'Complete',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
