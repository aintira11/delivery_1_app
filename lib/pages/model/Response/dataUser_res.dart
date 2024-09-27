// To parse this JSON data, do
//
//     final datauserRes = datauserResFromJson(jsonString);

import 'dart:convert';

List<DatauserRes> datauserResFromJson(String str) => List<DatauserRes>.from(json.decode(str).map((x) => DatauserRes.fromJson(x)));

String datauserResToJson(List<DatauserRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DatauserRes {
    int userId;
    String name;
    String password;
    int phone;
    String address;
    String image;
    double latitude;
    double longitude;
    String userType;

    DatauserRes({
        required this.userId,
        required this.name,
        required this.password,
        required this.phone,
        required this.address,
        required this.image,
        required this.latitude,
        required this.longitude,
        required this.userType,
    });

    factory DatauserRes.fromJson(Map<String, dynamic> json) => DatauserRes(
        userId: json["user_id"],
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        image: json["image"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "password": password,
        "phone": phone,
        "address": address,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
        "user_type": userType,
    };
}
