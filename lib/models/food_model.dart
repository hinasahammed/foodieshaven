// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class FoodModel {
  final String id;
  final String category;
  final String desc;
  final String price;
  final String rating;
  final String time;
  final String title;
  final String url;
  final bool special;
  final bool isFavourite;

  FoodModel({
    required this.id,
    required this.category,
    required this.desc,
    required this.price,
    required this.rating,
    required this.time,
    required this.title,
    required this.url,
    required this.special,
    this.isFavourite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'desc': desc,
      'price': price,
      'rating': rating,
      'time': time,
      'title': title,
      'url': url,
      'special': special,
      'isFavourite': isFavourite,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id'] as String,
      category: map['category'] as String,
      desc: map['desc'] as String,
      price: map['price'] as String,
      rating: map['rating'] as String,
      time: map['time'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
      special: map['special'] as bool,
      isFavourite: map['isFavourite'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
