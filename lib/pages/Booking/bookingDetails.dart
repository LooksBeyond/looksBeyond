import 'package:cached_network_image/cached_network_image.dart';
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

  String formatDateTime(String value) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(value));
    final formattedDateTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formattedDateTime;
  }

  String formatDate(String dateStr) {
    final dateParts = dateStr.split(' ')[0].split('-');
    final day = dateParts[2];
    final month = dateParts[1];
    final year = dateParts[0];
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    booking = ModalRoute.of(context)!.settings.arguments as UserBooking;
    String formattedDateTime = formatDateTime(booking.dateTime.toString());
    String formattedBookingDate = formatDate(booking.date);
    return Scaffold(
      backgroundColor: Color(0xffececec),
      appBar: AppBar(
        backgroundColor: Color(0xffececec),
        title: Text(
          'Booking Details',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (booking.status == Status.active) ...[
                      _buildQrCode(booking.id.toString()),
                      Center(
                        child: Text("Show this QR Code when service is completed"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                    // _buildDetail('Booking ID', booking.id.toString()),
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
                          var brandLogo = snapshot.data!['logo'];
                          var brandCity = snapshot.data!['city'];
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    brandLogo.toString(),
                                  ),
                                  radius: 35,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        brandName,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        brandCity,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    Wrap(
                      children: [
                        _buildDetail('Title', booking.title, context),
                        _buildDetail('Booked on', formattedDateTime, context),
                        _buildDetail('Booking Date', formattedBookingDate, context),
                        _buildDetail('Time Slot', booking.timeSlot, context),
                        _buildDetail(
                            'Price', "\$${booking.total.toString()}", context),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('employee')
                              .doc(booking.employee)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              var employeeName = snapshot.data!['name'];
                              return _buildDetail(
                                  'Stylist', "$employeeName", context);
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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

  Widget _buildDetail(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffececec),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.0,
                color: Color(0xff7c7c7c),
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
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
  return Container(
    height: 230,
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
