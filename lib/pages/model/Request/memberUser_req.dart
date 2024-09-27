// To parse this JSON data, do
//
//     final memberRes = memberResFromJson(jsonString);

import 'dart:convert';

MemberRes memberResFromJson(String str) => MemberRes.fromJson(json.decode(str));

String memberResToJson(MemberRes data) => json.encode(data.toJson());

class MemberRes {
    String name;
    String password;
    String phone;
    String address;
    String image;
    double latitude;
    double longitude;

    MemberRes({
        required this.name,
        required this.password,
        required this.phone,
        required this.address,
        required this.image,
        required this.latitude,
        required this.longitude,
    });

    factory MemberRes.fromJson(Map<String, dynamic> json) => MemberRes(
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        image: json["image"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
        "phone": phone,
        "address": address,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
    };
}
