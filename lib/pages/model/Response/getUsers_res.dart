// To parse this JSON data, do
//
//     final getUsersRes = getUsersResFromJson(jsonString);
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

List<GetUsersRes> getUsersResFromQuerySnapshot(QuerySnapshot snapshot) =>
    List<GetUsersRes>.from(snapshot.docs.map((doc) => GetUsersRes.fromJson(doc.data() as Map<String, dynamic>, doc.id)));

String getUsersResToJson(List<GetUsersRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsersRes {
    String id;
    String name;
    String password;
    String phone;
    String address;
    String image;
    double latitude;
    double longitude;
    String type;

    GetUsersRes({
        required this.id,
        required this.name,
        required this.password,
        required this.phone,
        required this.address,
        required this.image,
        required this.latitude,
        required this.longitude,
        required this.type,
    });

    factory GetUsersRes.fromJson(Map<String, dynamic> json, String docId) => GetUsersRes(
        id: docId,
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        image: json["image"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "phone": phone,
        "address": address,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
        "type": type,
    };
}
