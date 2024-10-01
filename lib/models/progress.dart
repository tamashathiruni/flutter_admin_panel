import 'package:flutter/material.dart';

class userprogress {
  final String id;
  final double Jumping_Jack;

  final double Rest_and_Drink;

  final double Skipping;

  final double Warm_Up;

  userprogress(
      {required this.id,
      required this.Jumping_Jack,
      required this.Rest_and_Drink,
      required this.Skipping,
      required this.Warm_Up});

  factory userprogress.fromMap(String id, Map<String, dynamic> data) {
    return userprogress(
      id: data['id'] ?? '',
      Jumping_Jack: (data['Jumping Jack'] ?? 0).toDouble(),
      Rest_and_Drink: (data['Rest and Drink'] ?? 0).toDouble(),
      Skipping: (data['Skipping'] ?? 0).toDouble(),
      Warm_Up: (data['Warm Up'] ?? 0).toDouble(),
    );
  }
}
