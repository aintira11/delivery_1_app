// To parse this JSON data, do
//
//     final loginRes = loginResFromJson(jsonString);

import 'dart:convert';

List<LoginRes> loginResFromJson(String str) => List<LoginRes>.from(json.decode(str).map((x) => LoginRes.fromJson(x)));

String loginResToJson(List<LoginRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginRes {
    int id;
    String username;
    String phone;
    String userType;

    LoginRes({
        required this.id,
        required this.username,
        required this.phone,
        required this.userType,
    });

    factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        id: json["id"],
        username: json["username"],
        phone: json["phone"],
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "phone": phone,
        "user_type": userType,
    };
}
