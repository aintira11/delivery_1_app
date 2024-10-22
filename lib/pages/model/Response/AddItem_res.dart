// To parse this JSON data, do
//
//     final getAddItemRes = getAddItemResFromJson(jsonString);

import 'dart:convert';

GetAddItemRes getAddItemResFromJson(String str) => GetAddItemRes.fromJson(json.decode(str));

String getAddItemResToJson(GetAddItemRes data) => json.encode(data.toJson());

class GetAddItemRes {
  String? order_id;
  String? detail;
  String? image;
  String? id;

  GetAddItemRes({
    required this.order_id,
    required this.detail,
    required this.image,
    this.id,
  });

  // Factory method สำหรับสร้าง Object จาก JSON (Map<String, dynamic>)
  factory GetAddItemRes.fromJson(Map<String, dynamic> json, {String? id}) {
    return GetAddItemRes(
      order_id: json['order_id'] as String?,
      detail: json['detail'] as String?,
      image: json['image'] as String?,
      id: id, // กำหนด ID ถ้าส่งมาจาก DocumentReference
    );
  }

  // Method สำหรับแปลง Object เป็น JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'detail': detail,
      'image': image,
    };
  }
}
