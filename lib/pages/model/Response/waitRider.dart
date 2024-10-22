// To parse this JSON data, do
//
//     final dataSenderWaitRes = dataSenderWaitResFromJson(jsonString);

import 'dart:convert';

List<DataSenderWaitRes> dataSenderWaitResFromJson(String str) => List<DataSenderWaitRes>.from(json.decode(str).map((x) => DataSenderWaitRes.fromJson(x)));

String dataSenderWaitResToJson(List<DataSenderWaitRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataSenderWaitRes {
    String orderId;
    OrderDetails orderDetails;
    List<ReceiverInfo> receiverInfo;

    DataSenderWaitRes({
        required this.orderId,
        required this.orderDetails,
        required this.receiverInfo,
    });

    factory DataSenderWaitRes.fromJson(Map<String, dynamic> json) => DataSenderWaitRes(
        orderId: json["order_id"],
        orderDetails: OrderDetails.fromJson(json["order_details"]),
        receiverInfo: List<ReceiverInfo>.from(json["receiver_info"].map((x) => ReceiverInfo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_details": orderDetails.toJson(),
        "receiver_info": List<dynamic>.from(receiverInfo.map((x) => x.toJson())),
    };
}

class OrderDetails {
    String receiverId;
    List<StatusHistory> statusHistory;
    dynamic currentStatus;
    dynamic imageUrl1;
    List<Item> items;

    OrderDetails({
        required this.receiverId,
        required this.statusHistory,
        required this.currentStatus,
        required this.imageUrl1,
        required this.items,
    });

    factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        receiverId: json["receiver_id"],
        statusHistory: List<StatusHistory>.from(json["status_history"].map((x) => StatusHistory.fromJson(x))),
        currentStatus: json["current_status"],
        imageUrl1: json["image_url_1"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "receiver_id": receiverId,
        "status_history": List<dynamic>.from(statusHistory.map((x) => x.toJson())),
        "current_status": currentStatus,
        "image_url_1": imageUrl1,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    String image;
    String detail;

    Item({
        required this.image,
        required this.detail,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        image: json["image"],
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "detail": detail,
    };
}

class StatusHistory {
    dynamic imageUrl4;
    String note;
    dynamic imageUrl1;
    dynamic imageUrl2;
    String status;

    StatusHistory({
        required this.imageUrl4,
        required this.note,
        required this.imageUrl1,
        required this.imageUrl2,
        required this.status,
    });

    factory StatusHistory.fromJson(Map<String, dynamic> json) => StatusHistory(
        imageUrl4: json["image_url_4"],
        note: json["note"],
        imageUrl1: json["image_url_1"],
        imageUrl2: json["image_url_2"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "image_url_4": imageUrl4,
        "note": note,
        "image_url_1": imageUrl1,
        "image_url_2": imageUrl2,
        "status": status,
    };
}

class ReceiverInfo {
    String image;
    String password;
    String address;
    String phone;
    double latitude;
    String name;
    String type;
    double longitude;

    ReceiverInfo({
        required this.image,
        required this.password,
        required this.address,
        required this.phone,
        required this.latitude,
        required this.name,
        required this.type,
        required this.longitude,
    });

    factory ReceiverInfo.fromJson(Map<String, dynamic> json) => ReceiverInfo(
        image: json["image"],
        password: json["password"],
        address: json["address"],
        phone: json["phone"],
        latitude: json["latitude"]?.toDouble(),
        name: json["name"],
        type: json["type"],
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "password": password,
        "address": address,
        "phone": phone,
        "latitude": latitude,
        "name": name,
        "type": type,
        "longitude": longitude,
    };
}
