import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looksbeyond/models/user_booking.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookings',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: Please try again later.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<UserBooking> bookings = snapshot.data!.docs.map((doc) {
            return UserBooking.fromFireStore(doc);
          }).toList();

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                leading: Container(
                  height: 60,
                  width: 60,
                  child: CachedNetworkImage(
                    imageUrl: booking.empImage!,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 30,
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
                title: Text(
                  booking.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  booking.date.split(" ")[0].toString() +
                      " at " +
                      booking.timeSlot,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: SvgPicture.asset(
                  'assets/img/booking_status.svg',
                  color: _getStatusColor(booking.status),
                  height: 15,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/booking_details',
                      arguments: booking);
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.active:
        return Color(0xff6fc276);
      case Status.completed:
        return Color(0xff98BAD5);
      case Status.refunded:
        return Color(0xffff6961);
      default:
        return Colors.black;
    }
  }
}
