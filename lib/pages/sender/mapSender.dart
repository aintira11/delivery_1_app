import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapSenderPage extends StatefulWidget {
  const MapSenderPage({super.key});

  @override
  State<MapSenderPage> createState() => _MapSenderPageState();
}

class _MapSenderPageState extends State<MapSenderPage> {
  LatLng latLng1 =
      const LatLng(15.998009549056942, 102.53815639596311); // จุดแรก
  LatLng latLng2 = const LatLng(
      15.998509549056942, 102.53865639596311); // จุดที่สองใกล้ๆ กับจุดแรก
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Status'),
      ),
      body: Stack(
        children: [
          // แผนที่
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: latLng1,
              initialZoom: 17.0,
              minZoom: 10.0,
              maxZoom: 19.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}@2x.png',
                subdomains: ['a', 'b', 'c'],
                maxNativeZoom: 19,
                maxZoom: 19,
                userAgentPackageName: 'com.example.app',
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
          // ปุ่มซ้อนทับบนแผนที่
          Positioned(
            bottom: 20, // ปุ่มจะอยู่ห่างจากด้านล่างของหน้าจอ 20 พิกเซล
            left: 20,
            right: 20,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 60, // ความสูงของปุ่ม
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // เพิ่ม action สำหรับปุ่ม Order
                      _showOrderDialog(context);
                    },
                    child: const Text(
                      'Order',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // เว้นระหว่างปุ่ม
                SizedBox(
                  width: double.infinity,
                  height: 60, // ความสูงของปุ่ม
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // เพิ่ม action สำหรับปุ่ม Rider
                      _showOrderDialogRider(context);
                    },
                    child: const Text(
                      'Rider',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // ฟังก์ชันสำหรับแสดงป๊อปอัป
  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBE9E7),
          title: const Text('Sent To',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name: Shino'),
              const Text('Phone: 0555555555'),
              const Text('Address: 88/1 aaa kkk mkmk'),
              const Divider(),
              const Text('Order Number : 90'),
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // ให้ส่วนที่อยู่สูงสุดตรงกัน
                children: [
                  // รูปภาพ
                  Row(
                    children: [
                      Image.network(
                        'https://api2.krua.co/wp-content/uploads/2022/05/RT1719_ImageBanner_1140x507-4.jpg',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 20),
                      Text('ไก่ย่าง'),
                      // เว้นระยะระหว่างรูปภาพ
                    ],
                  ),
                  const SizedBox(width: 10), // เว้นระยะระหว่างรูปและข้อความ
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOrderDialogRider(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF3E0), // สีพื้นหลังป๊อปอัป
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // ขอบมุมโค้งของป๊อปอัป
          ),
          titlePadding: const EdgeInsets.all(0), // กำหนด padding ของ title
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          title: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE0B2), // สีหัวข้อ
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Center(
              child: Text(
                'Rider',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://i.imgur.com/BoN9kdC.png', // ใส่ลิงก์ของรูปภาพ rider ที่ต้องการ
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Name : Rider 2',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                'Phone : 0958745632',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                '2 กข 1218',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // สีปุ่ม OK
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
