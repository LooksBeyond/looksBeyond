import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:looksbeyond/pages/CreateBooking/CreateBooking.dart';

class ServiceEmployees extends StatefulWidget {
  static const String pageName = "/serviceEmployees";
  const ServiceEmployees({super.key});

  @override
  State<ServiceEmployees> createState() => _ServiceEmployeesState();
}

class _ServiceEmployeesState extends State<ServiceEmployees> {
  late Stream<List<DocumentSnapshot>> _employeesStream;
  late DocumentSnapshot service;

  @override
  void initState() {
    super.initState();
  }

  Stream<List<DocumentSnapshot>> _getEmployeesStream(String serviceId) {
    return FirebaseFirestore.instance
        .collection('employee')
        .where('services.$serviceId', isNotEqualTo: "")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    service = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    _employeesStream = _getEmployeesStream(service.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Stylist'),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _employeesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<DocumentSnapshot>? employees = snapshot.data;
          if (employees == null || employees.isEmpty) {
            return Center(child: Text('No employees found.'));
          }
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              DocumentSnapshot employee = employees[index];
              // Customize how each employee is displayed in the list
              return ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(CreateBooking.pageName, arguments: {'employee': employee, 'service': service});
                },
                title: Text(employee['name']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(employee['img']),
                ),
                subtitle: Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: employee['avgRating'] as double,
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
                    Text("(" + employee["numberOfRatings"].toString() + ")")
                  ],
                ),
                trailing: Text(
                  "\$" + employee['services'][service.id].toString(),
                  style: TextStyle(fontSize: 17),
                ),
                // Add more fields as needed
              );
            },
          );
        },
      ),
    );
  }
}
