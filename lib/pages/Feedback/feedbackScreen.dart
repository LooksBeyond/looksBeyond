import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextEditingController _commentController = TextEditingController();
  late UserBooking booking;
  bool isReviewExist = false;
  late LoggedInUser loggedInUser;
  late ValueNotifier<double> _ratingNotifier;
  double _rating = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ratingNotifier = ValueNotifier<double>(0.0);
  }

  String getEmoji(double rating) {
    if (rating <= 1) {
      return '😡'; // Angry
    } else if (rating <= 2) {
      return '👌'; // Ok
    } else if (rating <= 3) {
      return '😊'; // Good
    } else if (rating <= 4) {
      return '😄'; // Better
    } else {
      return '🤩'; // Best
    }
  }

  String getPhrase(double rating) {
    if (rating <= 1) {
      return 'Not Good'; // Angry
    } else if (rating <= 2) {
      return 'Could be better'; // Ok
    } else if (rating <= 3) {
      return 'Hmm...just ok!'; // Good
    } else if (rating <= 4) {
      return 'Very Good'; // Better
    } else {
      return 'Amazing Experience'; // Best
    }
  }

  @override
  Widget build(BuildContext context) {
    booking = ModalRoute.of(context)!.settings.arguments as UserBooking;
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    loggedInUser = authenticationProvider.loggedInUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isReviewExist ? "Edit Feedback" : 'Provide Feedback',
        ),
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  final reviewDocs = snapshot.data!.docs;
                  if (reviewDocs.isNotEmpty) {
                    isReviewExist = true;
                    final reviewDoc = reviewDocs.first;
                    _rating = reviewDoc['rating'] ?? 0.0;
                    _commentController.text = reviewDoc['comment'] ?? '';
                    _ratingNotifier = ValueNotifier<double>(_rating);
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
                      "Rate your experience! 👋🏻",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "We would love to hear from you! How was your experience for ${booking.title}?",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        ValueListenableBuilder<double>(
                          valueListenable: _ratingNotifier,
                          builder: (context, rating, _) {
                            return Text(
                              getEmoji(rating),
                              style: TextStyle(fontSize: 40),
                            );
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RatingBar.builder(
                          glow: true,
                          glowColor: Colors.yellow,
                          unratedColor: Colors.grey[300],
                          allowHalfRating: true,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          onRatingUpdate: (value) {
                            _ratingNotifier.value = value;
                          },
                          initialRating: _ratingNotifier.value,
                          itemCount: 5,
                          maxRating: 5,
                        ),
                      ],
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: _ratingNotifier,
                      builder: (context, rating, _) {
                        return Text(
                          getPhrase(rating),
                          style: GoogleFonts.redHatDisplay(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Set border radius
                          borderSide: BorderSide(
                            color: Colors.blue, // Set border color
                            width: 2.0, // Set border width
                          ),
                        ),
                        hintText: 'Any comments for us?',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        _submitFeedback();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
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
                );
              }
            }),
      ),
    );
  }

  void _submitFeedback() async {
    // Submit feedback logic
    double rating = _rating;
    String comment = _commentController.text;

    String reviewDocId;

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
        reviewDocId = reviewDoc.id;
      }
    } else {
      // If review doesn't exist, create a new review document
      DocumentReference newReviewRef =
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
      reviewDocId = newReviewRef.id;
      // Update booking document with review ID
      FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
        'review': reviewDocId,
      });
    }

    // Calculate new avgRating and numberOfRatings
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference employeeRef = FirebaseFirestore.instance
          .collection('employee')
          .doc(booking.employee);

      DocumentSnapshot snapshot = await transaction.get(employeeRef);

      int numberOfRatings = isReviewExist
          ? int.parse(snapshot['numberOfRatings'].toString())
          : int.parse(snapshot['numberOfRatings'].toString()) + 1;
      double currentAvgRating = double.parse(snapshot['avgRating'].toString());
      double newAvgRating =
          (currentAvgRating * (numberOfRatings - 1) + rating) / numberOfRatings;

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
    _ratingNotifier.dispose();
    super.dispose();
  }
}
