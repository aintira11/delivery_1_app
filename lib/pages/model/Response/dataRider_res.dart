// To parse this JSON data, do
//
//     final datariderRes = datariderResFromJson(jsonString);

import 'dart:convert';

DatariderRes datariderResFromJson(String str) => DatariderRes.fromJson(json.decode(str));

String datariderResToJson(DatariderRes data) => json.encode(data.toJson());

class DatariderRes {
    String image;
    String password;
    String phone;
    String name;
    String type;
    String vehicle;

    DatariderRes({
        required this.image,
        required this.password,
        required this.phone,
        required this.name,
        required this.type,
        required this.vehicle,
    });

    factory DatariderRes.fromJson(Map<String, dynamic> json) => DatariderRes(
        image: json["image"],
        password: json["password"],
        phone: json["phone"],
        name: json["name"],
        type: json["type"],
        vehicle: json["vehicle"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "password": password,
        "phone": phone,
        "name": name,
        "type": type,
        "vehicle": vehicle,
    };
}
