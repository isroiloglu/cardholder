import 'package:flutter/material.dart';

//
// class CardModel {
//   final int id;
//   final String owner;
//   final int balance;
//   final String number;
//   final Color? color;
//   final List<Color>? gradient;
//   final String? image;
//
//   CardModel(
//       {required this.id,
//       this.color,
//       this.gradient,
//       this.image,
//       required this.owner,
//       required this.balance,
//       required this.number});
// }
// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

class CardModel {
  final int id;
  final String owner;
  final int balance;
  final double? blur;
  final String number;
  final Color? color;
  final List<Color>? gradient;
  final String? image;

  CardModel(
      {required this.id,
      this.color,
      this.blur,
      this.gradient,
      this.image,
      required this.owner,
      required this.balance,
      required this.number});

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json["id"],
        owner: json["owner"],
        balance: json["balance"],
        number: json["number"],
        color: json["color"],
        gradient: List<Color>.from(json["gradient"].map((x) => Color(x))),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "balance": balance,
        "number": number,
        if (image != null) "blur": blur,
        if (color != null) "color": color?.value,
        if (gradient != null)
          "gradient": List<dynamic>.from(gradient!.map((x) => x.value)),
      };
}
