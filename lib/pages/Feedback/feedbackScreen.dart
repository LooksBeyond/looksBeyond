import 'package:flutter/material.dart';
import 'package:looksbeyond/models/user_booking.dart';

class FeedbackPage extends StatefulWidget {
  static const String pageName = '/feedback';


  const FeedbackPage({
    Key? key,

  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0.0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  final UserBooking booking = ModalRoute.of(context)!.settings.arguments as UserBooking;
    return Scaffold(
      appBar: AppBar(
        title: Text('Provide Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${booking.title}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Stylist: ${booking.stylist}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Brand: ${booking.brand}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Rating:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Slider(
              value: _rating,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.toStringAsFixed(1),
            ),
            SizedBox(height: 20.0),
            Text(
              'Feedback:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your feedback...',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _submitFeedback();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    // Submit feedback logic
    double rating = _rating;
    String comment = _commentController.text;


    // After submitting, you can navigate back to the previous screen.
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
