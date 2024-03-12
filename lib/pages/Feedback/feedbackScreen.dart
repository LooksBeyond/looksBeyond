import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:looksbeyond/models/logged_in_user.dart';
import 'package:looksbeyond/models/user_booking.dart';
import 'package:looksbeyond/provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  static const String pageName = '/feedback';

  const FeedbackPage({
    Key? key,
  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late AuthenticationProvider authenticationProvider;
  double _rating=0.0;
  TextEditingController _commentController = TextEditingController();
  late UserBooking booking;
  bool isReviewExist = false;
  late LoggedInUser loggedInUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    booking = ModalRoute.of(context)!.settings.arguments as UserBooking;
    authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    loggedInUser = authenticationProvider.loggedInUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(isReviewExist ? "Edit Feedback" : 'Provide Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('reviews')
              .where('bookingId', isEqualTo: booking.id)
              .limit(1)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                final reviewDocs = snapshot.data!.docs;
                if (reviewDocs.isNotEmpty) {
                  isReviewExist = true;
                  final reviewDoc = reviewDocs.first;
                  _rating = reviewDoc['rating'] ?? 0.0;
                  _commentController.text = reviewDoc['comment'] ?? '';
                } else {
                  isReviewExist = false;
                  _rating = 0.0;
                  _commentController.text = '';
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service: ${booking.title}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Stylist: ${booking.employee}',
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
                  RatingBar(
                    glow: true,
                    glowColor: Colors.yellow,
                    unratedColor: Colors.grey[300],
                    allowHalfRating: true,
                    ratingWidget: RatingWidget(
                      full: Icon(Icons.star, color: Colors.yellow,),
                      half: Icon(Icons.star_half, color: Colors.yellow,),
                      empty: Icon(Icons.star_border, color: Colors.grey[300],),
                    ),
                    onRatingUpdate: (value) {
                        _rating = value;
                    },
                    initialRating: _rating,
                    maxRating: 5,
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
              );
            }
          },
        ),
      ),
    );
  }


  void checkReviewExistence() async {
    if (!mounted) {
      return; // Return early if the widget is disposed
    }

    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('bookingId', isEqualTo: booking.id)
        .limit(1)
        .get();

    if (!mounted) {
      return; // Return if the widget is disposed after the query completes
    }

    setState(() {
      isReviewExist = reviewSnapshot.docs.isNotEmpty;
    });

    if (isReviewExist) {
      // If a review exists, populate the feedback fields with existing review data
      DocumentSnapshot reviewDoc = reviewSnapshot.docs.first;
      double existingRating = reviewDoc['rating'];
      String existingComment = reviewDoc['comment'];

      if (!mounted) {
        return; // Return if the widget is disposed before updating state
      }

      setState(() {
        _rating = existingRating;
        _commentController.text = existingComment;
      });
    }
  }

  void _submitFeedback() async {
    // Submit feedback logic
    double rating = _rating;
    String comment = _commentController.text;

    if (isReviewExist) {
      // If review exists, update the existing review document
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('bookingId', isEqualTo: booking.id)
          .limit(1)
          .get();

      if (reviewSnapshot.docs.isNotEmpty) {
        DocumentSnapshot reviewDoc = reviewSnapshot.docs.first;
        reviewDoc.reference.update({
          'rating': rating,
          'comment': comment,
          'timestamp': Timestamp.now(),
        });
      }
    } else {
      // If review doesn't exist, create a new review document
      await FirebaseFirestore.instance.collection('reviews').add({
        'userName': loggedInUser.name,
        'bookingId': booking.id,
        'rating': rating,
        'comment': comment,
        'timestamp': Timestamp.now(),
        'empId': booking.employee,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'brandId': booking.brand,
      });
    }

    // Calculate new avgRating and numberOfRatings
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference employeeRef = FirebaseFirestore.instance.collection('employee').doc(booking.employee);

      DocumentSnapshot snapshot = await transaction.get(employeeRef);

      int numberOfRatings = isReviewExist
          ? int.parse(snapshot['numberOfRatings'].toString())
          : int.parse(snapshot['numberOfRatings'].toString()) + 1;
      double currentAvgRating = double.parse(snapshot['avgRating'].toString());
      double newAvgRating = (currentAvgRating * (numberOfRatings - 1) + rating) /
          numberOfRatings;

      // Update the employee document
      transaction.update(employeeRef, {
        'numberOfRatings': numberOfRatings,
        'avgRating': newAvgRating,
      });
    });

    // After submitting, you can navigate back to the previous screen.
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
