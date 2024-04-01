import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:looksbeyond/models/user_booking.dart';
import 'package:looksbeyond/pages/EmployeeInfo/EmployeeInfoScreen.dart';
import 'package:looksbeyond/pages/Payment/PaymentScreen.dart';

class CreateBooking extends StatefulWidget {
  static const String pageName = "/createBooking";
  const CreateBooking({super.key});

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  UserBooking? userBooking;
  double subtotal = 0;
  String? _selectedTimeslot;
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  late Map arguments;
  late DocumentSnapshot employee;
  late DocumentSnapshot service;
  late Future<List<DocumentSnapshot>> _brandStream;
  late DocumentSnapshot brandSnapshot;

  // Fetch brands from Firebase where the employees list contains the employee ID
  Future<List<DocumentSnapshot>> _fetchBrand(String employeId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('brands')
        .where('employees', arrayContains: employeId)
        .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    employee = arguments['employee'];
    service = arguments['service'];
    _brandStream = _fetchBrand(employee.id);
    subtotal = employee['services'][service.id] +
        (employee['services'][service.id] * 0.2);
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "Subtotal: " + subtotal.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10)),
                  height: 40,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedTimeslot != null) {
                          userBooking = UserBooking(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              isPaid: false,
                              timeSlot: _selectedTimeslot!,
                              date: _selectedDate.toString(),
                              subtotal: double.parse(employee['services'][service.id].toString()),
                              platformPrice: employee['services'][service.id] * 0.2,
                              total: 0,
                              service: service.id,
                              id: "",
                              title:
                                  service['name'] + " by " + employee['name'],
                              dateTime: DateTime.now().millisecondsSinceEpoch,
                              status: Status.active,
                              employee: employee['name'],
                              brand: brandSnapshot['brand']);
                          Navigator.of(context)
                              .pushNamed(PaymentScreen.pageName, arguments: {
                            "userBooking": userBooking,
                            "employee": employee,
                            "brand": brandSnapshot,
                            "service": service
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (dialogcContext) {
                                return Dialog(
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      height: 150,
                                      width: 200,
                                      child: Center(
                                          child: Text(
                                        "Select timeslot first. Thankyou.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red),
                                      )),
                                    ));
                              });
                        }
                      },
                      child: Text(
                        'Confirm Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _brandStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DocumentSnapshot>? brand = snapshot.data;
                    brandSnapshot = brand![0];
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              child: CachedNetworkImage(
                                imageUrl: brand[0]['logo'],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                brand[0]['brand'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 5),
                              )),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                        child: Text(
                      "Excited enough? Only some last steps for your booking to complete your service.",
                      style: TextStyle(fontSize: 17),
                    )),
                    Text(
                      "Get Ready for your " +
                          service['name'] +
                          ". It usually takes ${service['time']} minutes",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 20),
                    _buildTimeSlotDropdown(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date:',
                          style: TextStyle(fontSize: 17),
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 30)),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                setState(() {
                                  _selectedDate = selectedDate;
                                });
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Selected Stylist:',
                      style: TextStyle(fontSize: 17),
                    ),
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl: employee['img'],
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 25,
                            backgroundImage: imageProvider,
                          ),
                        ),
                      ),
                      title: Text(employee['name']), // Employee name
                      subtitle: Row(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: double.parse(employee['avgRating'].toString()),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Text("(" +
                              employee["numberOfRatings"].toString() +
                              ")")
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EmployeeInfoScreen.pageName,
                              arguments: employee);
                        },
                        child: Text("View More"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(fontSize: 17),
                        ),
                        Container(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service price",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "\$" +
                                        employee['services'][service.id]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Platform price",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "\$" +
                                        (employee['services'][service.id] * 0.2)
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotDropdown() {
    return TimeSlotDropdown(
      value: _selectedTimeslot,
      onChanged: (String? newValue) {
        _selectedTimeslot = newValue;
      },
    );
  }

}


class TimeSlotDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String? value;

  const TimeSlotDropdown({
    Key? key,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  @override
  _TimeSlotDropdownState createState() => _TimeSlotDropdownState();
}

class _TimeSlotDropdownState extends State<TimeSlotDropdown> {
  late String? _selectedTimeslot;

  @override
  void initState() {
    super.initState();
    _selectedTimeslot = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select Timeslot:',
          style: TextStyle(fontSize: 17),
        ),
        DropdownButton<String>(
          value: _selectedTimeslot,
          onChanged: (String? newValue) {
            setState(() {
              _selectedTimeslot = newValue;
            });
            widget.onChanged(newValue);
          },
          items: <String>[
            '10:00 AM',
            '12:00 PM',
            '2:00 PM',
            '4:00 PM'
          ]
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
              .toList(),
        ),
      ],
    );
  }
}