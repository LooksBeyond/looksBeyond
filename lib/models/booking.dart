import 'package:flutter/material.dart';

enum Status {
  active,
  completed,
  refunded,
}

class Booking {
  final String id;
  final String title;
  final String dateTime;
  final Status status;
  final String stylist;
  final String shopName;

  Booking({required this.id, required this.title, required this.dateTime, required this.status, required this.stylist, required this.shopName, });
}
