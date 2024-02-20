import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateBooking extends StatefulWidget {
  static const String pageName = "/createBooking";
  const CreateBooking({super.key});

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  String? _selectedBrand;
  String? _selectedTimeslot;
  DateTime _selectedDate = DateTime.now();
  late Map arguments;
  late DocumentSnapshot employee;
  late Future<List<DocumentSnapshot>> _brandStream;

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
    _brandStream = _fetchBrand(employee.id);
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Text("Total: "),),
              Container(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 40,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Handle booking logic
                      },
                      child: Text('Confirm Booking', style: TextStyle(color: Colors.white),),
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
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              child: Image.network(
                                brand![0]['logo'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                brand[0]['brand'],
                                style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 5),
                              )),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Text('Select Timeslot:'),
              DropdownButton<String>(
                value: _selectedTimeslot,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeslot = newValue;
                  });
                },
                items: <String>['10:00 AM', '12:00 PM', '2:00 PM', '4:00 PM']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Text('Select Date:'),
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
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Selected Employee:'),
              ListTile(
                leading: CircleAvatar(
                  // Placeholder image or actual employee image
                  child: Icon(Icons.person),
                ),
                title: Text('John Doe'), // Employee name
                subtitle: Text('Hair Stylist'), // Employee role
              ),
              SizedBox(height: 20),
        
            ],
          ),
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedBrand;
  String? _selectedTimeslot;
  DateTime _selectedDate = DateTime.now();

  // Fetch brands from Firebase where the employees list contains the employee ID
  Future<List<String>> _fetchBrands() async {
    QuerySnapshot brandSnapshot = await FirebaseFirestore.instance
        .collection('brands')
        .where('employees', arrayContains: 'employeeId')
        .get();

    List<String> brands = [];
    brandSnapshot.docs.forEach((doc) {
      brands.add(doc['name']);
    });
    return brands;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Brand:'),
            FutureBuilder<List<String>>(
              future: _fetchBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return DropdownButton<String>(
                    value: _selectedBrand,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBrand = newValue;
                      });
                    },
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>(
                            (String brand) => DropdownMenuItem<String>(
                                  value: brand,
                                  child: Text(brand),
                                ))
                        .toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text('Select Timeslot:'),
            DropdownButton<String>(
              value: _selectedTimeslot,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTimeslot = newValue;
                });
              },
              items: <String>['10:00 AM', '12:00 PM', '2:00 PM', '4:00 PM']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text('Select Date:'),
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
                  Icon(Icons.calendar_today),
                  SizedBox(width: 10),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Selected Employee:'),
            ListTile(
              leading: CircleAvatar(
                // Placeholder image or actual employee image
                child: Icon(Icons.person),
              ),
              title: Text('John Doe'), // Employee name
              subtitle: Text('Hair Stylist'), // Employee role
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle booking logic
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
