//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  UserProfile _user = UserProfile();
  UserProfile get user => _user; // getter สำหรับข้อมูลผู้ใช้

  RiderProfile _rider = RiderProfile();
  RiderProfile get rider => _rider; // getter สำหรับข้อมูลผู้ขับขี่

  void updateUser(UserProfile newUser) {
    _user = newUser;
    notifyListeners(); // แจ้งให้ UI ทราบถึงการเปลี่ยนแปลง
  }

  void updateRider(RiderProfile newRider) {
    _rider = newRider;
    notifyListeners(); // แจ้งให้ UI ทราบถึงการเปลี่ยนแปลง
  }

  void clearUser() {
    _user = UserProfile();
    notifyListeners();
  }

  void clearRider() {
    _rider = RiderProfile();
    notifyListeners();
  }
}

class UserProfile {
  String id;
  String name;
  String password;
  String phone;
  String address;
  String image;
  double latitude;
  double longitude;
  String type;

  UserProfile({
    this.id = '',
    this.name = '',
    this.password = '',
    this.phone = '',
    this.address = '',
    this.image = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.type = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phone': phone,
      'address': address,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    };
  }
   @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, phone: $phone)';
  }
}

class RiderProfile {
  String id;
  String name;
  String password;
  String phone;
  String image;
  String vehicle;
  String type;

  RiderProfile({
    this.id = '',
    this.name = '',
    this.password = '',
    this.phone = '',
    this.image = '',
    this.vehicle = '',
    this.type = '',
  });

  factory RiderProfile.fromJson(Map<String, dynamic> json) {
    return RiderProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      vehicle: json['vehicle'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phone': phone,
      'image': image,
      'vehicle': vehicle,
      'type': type,
    };
  }
   @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, phone: $phone)';
  }
}
