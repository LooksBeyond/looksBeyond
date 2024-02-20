import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  active,
  completed,
  refunded,
}

class UserBooking {
  final String id;
  final String title;
  final String userId;
  final int dateTime;
  final Status status;
  final String stylist;
  final String brand;
  final bool isPaid;
  final String timeSlot;
  final String date;
  final double subtotal;
  final double total;
  final String service;

  UserBooking({
    required this.userId,
    required this.isPaid,
    required this.timeSlot,
    required this.date,
    required this.subtotal,
    required this.total,
    required this.service,
    required this.id,
    required this.title,
    required this.dateTime,
    required this.status,
    required this.stylist,
    required this.brand,
  });

  factory UserBooking.fromFireStore(DocumentSnapshot snapshot) {
    var data = snapshot.data()! as Map<String, dynamic>;
    print("Booking data::");
    print(data);

    var userBooking = UserBooking(
      id: snapshot.id,
      userId: data['userId']??'',
      title: data['title'] ?? '',
      dateTime: data['dateTime'] ?? '',
      status: Status.values[data['status']],
      stylist: data['stylist'] ?? '',
      brand: data['brand'] ?? '',
      isPaid: data['isPaid'] ?? false,
      timeSlot: data['timeSlot'] ?? '',
      date: data['date'] ?? '',
      subtotal: data['subtotal'] ?? 0.0,
      total: data['total'] ?? 0.0,
      service: data['service'] ?? '',
    );

    return userBooking;
  }
}
