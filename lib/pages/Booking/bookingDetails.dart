import 'package:flutter/material.dart';
import 'package:looksbeyond/models/booking.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    final Booking booking =
        ModalRoute.of(context)!.settings.arguments as Booking;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: ${booking.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              'Title: ${booking.title}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10),
            Text(
              'Date & Time: ${booking.dateTime}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10),
            // Additional booking details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salon/Spa: ABC Salon',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Stylist: John Doe',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Price: \$50',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                if (booking.status == Status.completed)
                  TextButton(
                    onPressed: () {
                      _navigateToFeedbackPage(context, booking);
                    },
                    child: Text(
                      'Write a Review',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFeedbackPage(BuildContext context, Booking booking) {
    Navigator.pushNamed(context, '/feedback', arguments: booking);
  }
}