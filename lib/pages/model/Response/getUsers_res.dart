// To parse this JSON data, do
//
//     final getUsersRes = getUsersResFromJson(jsonString);

import 'dart:convert';

List<GetUsersRes> getUsersResFromJson(String str) => List<GetUsersRes>.from(json.decode(str).map((x) => GetUsersRes.fromJson(x)));

String getUsersResToJson(List<GetUsersRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsersRes {
    int userId;
    String name;
    String password;
    String phone;
    String address;
    String image;
    double latitude;
    double longitude;
    String userType;

    GetUsersRes({
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

    factory GetUsersRes.fromJson(Map<String, dynamic> json) => GetUsersRes(
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
