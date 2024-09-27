import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_1_app/config/shared/app_data.dart';
import 'package:delivery_1_app/pages/home_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
//import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Connect to Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await GetStorage.init();
  //runApp(const MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppData(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light, // ใช้โหมดสว่าง
         primaryColor: Colors.white, // สีหลักเป็นสีขาว
        scaffoldBackgroundColor: Colors.white, // พื้นหลังเป็นสีขาว
        
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.black, // ใช้สีดำเป็นฟอนต์หลัก
          //surface: Colors.white,
          onSurface: Colors.black, // ใช้สีดำในพื้นผิว
        ),
      ),
      home: const HomeUserPage(),
    );
  }
}
