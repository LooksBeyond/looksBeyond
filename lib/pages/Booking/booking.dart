import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:looksbeyond/models/user_booking.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<UserBooking> bookings = [
    // UserBooking(id: '1', title: 'Spa Treatment', dateTime: 'Jan 20, 2024, 10:00 AM', status: Status.active, brand: "Shop 1", stylist: "Stylist 1"),
    // UserBooking(id: '2', title: 'Haircut', dateTime: 'Jan 25, 2024, 2:30 PM', status: Status.completed, stylist: "Stylist 2", brand: "Shop 2"),
    // UserBooking(id: '3', title: 'Manicure', dateTime: 'Jan 28, 2024, 4:00 PM', status: Status.refunded, stylist: "Stylist 3", brand: "Shop 3"),
  ];

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
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset('assets/img/avatar.png'),
            title: Text(
              bookings[index].title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              bookings[index].dateTime.toString(),
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            trailing: SvgPicture.asset('assets/img/booking_status.svg', color: _getStatusColor(bookings[index].status),height: 15,),
            onTap: () {
              Navigator.pushNamed(context, '/booking_details', arguments: bookings[index]);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
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
