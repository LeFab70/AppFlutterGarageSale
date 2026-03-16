import 'package:flutter/material.dart';

class Sale {
  String id;
  DateTime date;
  TimeOfDay start;
  TimeOfDay end;
  String item;

  Sale({
    required this.id,
    required this.date,
    required this.start,
    required this.end,
    required this.item,
  });
}