import 'package:flutter/material.dart';
import 'package:looksbeyond/models/user_booking.dart';
import 'package:looksbeyond/pages/Feedback/feedbackScreen.dart';

class BookingDetails extends StatefulWidget {
  static const String pageName = '/booking_details';

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late UserBooking booking;
  @override
  Widget build(BuildContext context) {
    booking =
    ModalRoute.of(context)!.settings.arguments as UserBooking;
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
            SizedBox(height: 20),
            Text(
              'Additional Details:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            BookingDetailItem(
              title: 'Salon/Spa',
              value: 'ABC Salon',
            ),
            BookingDetailItem(
              title: 'Stylist',
              value: 'John Doe',
            ),
            BookingDetailItem(
              title: 'Price',
              value: '\$50',
            ),
            if (booking.status == Status.completed) ...[
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _navigateToFeedbackPage(context, booking);
                },
                child: Text(
                  'Write a Review',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToFeedbackPage(BuildContext context, UserBooking booking) {
    Navigator.pushNamed(context, FeedbackPage.pageName, arguments: booking);
  }
}

class BookingDetailItem extends StatelessWidget {
  final String title;
  final String value;

  const BookingDetailItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
