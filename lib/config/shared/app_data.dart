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
  int userId;
  String name;
  String password;
  String phone;
  String address;
  String image;
  double latitude;
  double longitude;
  String userType;

  UserProfile({
    this.userId = 0,
    this.name = '',
    this.password = '',
    this.phone = '',
    this.address = '',
    this.image = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.userType = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      userType: json['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'password': password,
      'phone': phone,
      'address': address,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'user_type': userType,
    };
  }
}

class RiderProfile {
  int riderId;
  String riderName;
  String riderPassword;
  String riderPhone;
  String riderImage;
  String vehicle;
  String riderType;

  RiderProfile({
    this.riderId = 0,
    this.riderName = '',
    this.riderPassword = '',
    this.riderPhone = '',
    this.riderImage = '',
    this.vehicle = '',
    this.riderType = '',
  });

  factory RiderProfile.fromJson(Map<String, dynamic> json) {
    return RiderProfile(
      riderId: json['rider_id'] ?? 0,
      riderName: json['rider_name'] ?? '',
      riderPassword: json['rider_password'] ?? '',
      riderPhone: json['rider_phone'] ?? '',
      riderImage: json['rider_image'] ?? '',
      vehicle: json['vehicle'] ?? '',
      riderType: json['rider_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider_id': riderId,
      'rider_name': riderName,
      'rider_password': riderPassword,
      'rider_phone': riderPhone,
      'rider_image': riderImage,
      'vehicle': vehicle,
      'rider_type': riderType,
    };
  }
}
