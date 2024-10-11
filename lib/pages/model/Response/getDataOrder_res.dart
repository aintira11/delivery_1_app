// To parse this JSON data, do
//
//     final getDataOrderRes = getDataOrderResFromJson(jsonString);

import 'dart:convert';

GetDataOrderRes getDataOrderResFromJson(String str) => GetDataOrderRes.fromJson(json.decode(str));

String getDataOrderResToJson(GetDataOrderRes data) => json.encode(data.toJson());

class GetDataOrderRes {
    int orderId;
    List<Item> items;

    GetDataOrderRes({
        required this.orderId,
        required this.items,
    });

    factory GetDataOrderRes.fromJson(Map<String, dynamic> json) => GetDataOrderRes(
        orderId: json["order_id"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    int orderId;
    int senderId;
    int receiverId;
    int itemId;
    String detail;
    String image;

    Item({
        required this.orderId,
        required this.senderId,
        required this.receiverId,
        required this.itemId,
        required this.detail,
        required this.image,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        orderId: json["order_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        itemId: json["item_id"],
        detail: json["detail"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "item_id": itemId,
        "detail": detail,
        "image": image,
    };
}
