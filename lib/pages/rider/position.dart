import 'package:delivery_1_app/pages/rider/homeRider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class positionPage extends StatefulWidget {
  const positionPage({super.key});

  @override
  State<positionPage> createState() => _positionPageState();
}

class _positionPageState extends State<positionPage> {
  LatLng latLng1 =
      const LatLng(15.998009549056942, 102.53815639596311); // จุดแรก
  MapController mapController = MapController();

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
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
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
                  Text(
                    'Lat: ${latLng1.latitude} , Lng: ${latLng1.longitude}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  const Text(
                    'ตำแหน่ง: อำเภอเมือง, จังหวัดขอนแก่น, ประเทศไทย',
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
