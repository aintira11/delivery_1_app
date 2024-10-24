import 'package:delivery_1_app/pages/rider/homeRider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class positionPage extends StatefulWidget {
  final User sender;
  final User receiver;
  const positionPage({super.key, required this.sender, required this.receiver});

  @override
  State<positionPage> createState() => _positionPageState();
}

class _positionPageState extends State<positionPage> {
  // กำหนดพิกัดสำหรับผู้ส่งและผู้รับ
  late LatLng senderLatLng;
  late LatLng receiverLatLng;
  LatLng? riderLatLng; // พิกัดของไรเดอร์

  MapController mapController = MapController();
  @override
  void initState() {
    super.initState();
    // ใช้พิกัดจริงจากผู้ส่งและผู้รับ
    senderLatLng = LatLng(widget.sender.latitude, widget.sender.longitude);
    receiverLatLng =
        LatLng(widget.receiver.latitude, widget.receiver.longitude);
    _determineRiderPosition();
  }

  Future<void> _determineRiderPosition() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      riderLatLng = LatLng(position.latitude, position.longitude);
    });
  } catch (e) {
    print('Error determining rider position: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Position'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ไอคอนลูกศรย้อนกลับ
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RiderHomePage(),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: senderLatLng,
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
                  // Marker ผู้ส่ง
                  Marker(
                    point: senderLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  // Marker ผู้รับ
                  Marker(
                    point: receiverLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  // Marker ตำแหน่งปัจจุบันของไรเดอร์ (ถ้ามี)
                  if (riderLatLng != null)
                    Marker(
                      point: riderLatLng!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.directions_bike,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
          // แถบรายละเอียดที่อยู่ด้านล่างจอ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 176, 50),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // โค้งมุมซ้ายบน
                  topRight: Radius.circular(20), // โค้งมุมขวาบน
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // เงา
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -2), // ตำแหน่งเงา
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Location Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.red, // ตั้งค่าให้ไอคอนเป็นสีแดง
                        size: 20, // ขนาดของไอคอน
                      ),
                      SizedBox(width: 8), // เว้นระยะห่างระหว่างไอคอนกับข้อความ
                      Text(
                        'Sender Location',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'ตำแหน่ง : ${widget.sender.address}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Color.fromARGB(
                            255, 54, 120, 244), // ตั้งค่าให้ไอคอนเป็นสีฟ้า
                        size: 20, // ขนาดของไอคอน
                      ),
                      SizedBox(
                          width: 8), // เว้นระยะห่างระหว่างไอคอนกับข้อความ
                      Text(
                        'receiver Location',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'ตำแหน่ง: ${widget.receiver.address}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
