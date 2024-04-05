import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:looksbeyond/models/user_booking.dart';
import 'package:looksbeyond/pages/Feedback/feedbackScreen.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class BookingDetails extends StatefulWidget {
  static const String pageName = '/booking_details';

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late UserBooking booking;

  @override
  Widget build(BuildContext context) {
    booking = ModalRoute.of(context)!.settings.arguments as UserBooking;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.status == Status.active) ...[
                _buildQrCode(booking.id.toString()),
                Center(
                  child: Text("Show this QR Code when service is completed"),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
              _buildDetail('Booking ID', booking.id.toString()),
              _buildDetail('Title', booking.title),
              _buildDetail('Date & Time', booking.dateTime.toString()),
              SizedBox(height: 24),
              Text(
                'Additional Details:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('employee')
                    .doc(booking.employee)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    var employeeName = snapshot.data!['name'];
                    return BookingDetailItem(
                      title: "Stylist",
                      value: employeeName,
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('brands')
                    .doc(booking.brand)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    var brandName = snapshot.data!['brand'];
                    return BookingDetailItem(
                      title: "Brand",
                      value: brandName,
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              BookingDetailItem(
                title: 'Price',
                value: "\$${booking.total.toString()}",
              ),
              if (booking.status == Status.completed) ...[
                SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    _navigateToFeedbackPage(context, booking);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        'Submit a Review',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        SizedBox(height: 16),
      ],
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
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

Widget _buildQrCode(String bookingId) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Center(
      child: PrettyQrView.data(
        data: bookingId,
        errorCorrectLevel: QrErrorCorrectLevel.M,
        decoration: const PrettyQrDecoration(
          image: PrettyQrDecorationImage(
            image: AssetImage('assets/icon_black.png'),
          ),
        ),
      ),
    ),
  );
}
