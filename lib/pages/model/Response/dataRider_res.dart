// To parse this JSON data, do
//
//     final datariderRes = datariderResFromJson(jsonString);

import 'dart:convert';

List<DatariderRes> datariderResFromJson(String str) => List<DatariderRes>.from(json.decode(str).map((x) => DatariderRes.fromJson(x)));

String datariderResToJson(List<DatariderRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DatariderRes {
    int riderId;
    String riderName;
    String riderPassword;
    int riderPhone;
    String riderImage;
    String vehicle;
    String riderType;

    DatariderRes({
        required this.riderId,
        required this.riderName,
        required this.riderPassword,
        required this.riderPhone,
        required this.riderImage,
        required this.vehicle,
        required this.riderType,
    });

    factory DatariderRes.fromJson(Map<String, dynamic> json) => DatariderRes(
        riderId: json["rider_id"],
        riderName: json["rider_name"],
        riderPassword: json["rider_password"],
        riderPhone: json["rider_phone"],
        riderImage: json["rider_image"],
        vehicle: json["vehicle"],
        riderType: json["rider_type"],
    );

    Map<String, dynamic> toJson() => {
        "rider_id": riderId,
        "rider_name": riderName,
        "rider_password": riderPassword,
        "rider_phone": riderPhone,
        "rider_image": riderImage,
        "vehicle": vehicle,
        "rider_type": riderType,
    };
}
