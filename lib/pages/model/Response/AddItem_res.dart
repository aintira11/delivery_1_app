// To parse this JSON data, do
//
//     final getAddItemRes = getAddItemResFromJson(jsonString);

import 'dart:convert';

GetAddItemRes getAddItemResFromJson(String str) => GetAddItemRes.fromJson(json.decode(str));

String getAddItemResToJson(GetAddItemRes data) => json.encode(data.toJson());

class GetAddItemRes {
    int itemId;
    int orderId;
    String detail;
    String image;

    GetAddItemRes({
        required this.itemId,
        required this.orderId,
        required this.detail,
        required this.image,
    });

    factory GetAddItemRes.fromJson(Map<String, dynamic> json) => GetAddItemRes(
        itemId: json["item_id"],
        orderId: json["order_id"],
        detail: json["detail"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "order_id": orderId,
        "detail": detail,
        "image": image,
    };
}
