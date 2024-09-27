// To parse this JSON data, do
//
//     final riderRes = riderResFromJson(jsonString);

import 'dart:convert';

RiderRes riderResFromJson(String str) => RiderRes.fromJson(json.decode(str));

String riderResToJson(RiderRes data) => json.encode(data.toJson());

class RiderRes {
    String riderName;
    String riderPassword;
    String riderPhone;
    String riderImage;
    String vehicle;

    RiderRes({
        required this.riderName,
        required this.riderPassword,
        required this.riderPhone,
        required this.riderImage,
        required this.vehicle,
    });

    factory RiderRes.fromJson(Map<String, dynamic> json) => RiderRes(
        riderName: json["rider_name"],
        riderPassword: json["rider_password"],
        riderPhone: json["rider_phone"],
        riderImage: json["rider_image"],
        vehicle: json["vehicle"],
    );

    Map<String, dynamic> toJson() => {
        "rider_name": riderName,
        "rider_password": riderPassword,
        "rider_phone": riderPhone,
        "rider_image": riderImage,
        "vehicle": vehicle,
    };
}
