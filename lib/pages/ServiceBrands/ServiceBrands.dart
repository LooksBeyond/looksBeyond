import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:looksbeyond/models/brand.dart';
import 'package:looksbeyond/pages/BrandDisplay/BrandDisplayScreen.dart';
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

  Stream<List<DocumentSnapshot>> _getBrandsStream(String serviceId) async* {
    // Query for employee documents that match the service ID
    var querySnapshot = await FirebaseFirestore.instance
        .collection('employee')
        .where('services.$serviceId', isNotEqualTo: "")
        .get();

    // Extract employee IDs from the query snapshot
    List<String> employeeIds = querySnapshot.docs.map((doc) => doc.id).toList();
    print(employeeIds);

    // Fetch brand documents associated with the retrieved employee IDs
    var brandQuerySnapshot = await FirebaseFirestore.instance
        .collection('brands')
        .where('employees', arrayContainsAny: employeeIds)
        .get();

    print(brandQuerySnapshot.docs);

    // Yield the list of brand documents as the result
    yield brandQuerySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    service = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    _employeesStream = _getBrandsStream(service.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Brand'),
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
          List<DocumentSnapshot>? brands = snapshot.data;
          if (brands == null || brands.isEmpty) {
            return Center(child: Text('No employees found.'));
          }

          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              DocumentSnapshot brand = brands[index];
              // Customize how each employee is displayed in the list
              return ListTile(
                onTap: () {
                  // Navigator.of(context)
                  //     .pushNamed(CreateBooking.pageName, arguments: {'employee': brand, 'service': service});

                  Navigator.of(context).pushNamed(
                    BrandDisplayScreen.pageName,
                    arguments: {
                      'brand': new Brand.fromFirebase(brand),
                      'tabBarIndex': service,
                    },
                  );
                },
                title: Text(brand['brand']),
                leading: Container(
                  width: 45,
                  height: 45,
                  child: CachedNetworkImage(
                    imageUrl: brand['logo'],
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                  ),
                ),
                subtitle: Row(
                  children: [
                    // RatingBar.builder(
                    //   itemSize: 20,
                    //   initialRating: double.parse(brand['avgRating'].toString()),
                    //   minRating: 1,
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: true,
                    //   itemCount: 5,
                    //   ignoreGestures: true,
                    //   itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                    //   itemBuilder: (context, _) => Icon(
                    //     Icons.star,
                    //     color: Colors.amber,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     print(rating);
                    //   },
                    // ),
                    // Text("(" + brand["numberOfRatings"].toString() + ")")
                  ],
                ),
                trailing: Text(
                  brand['city'],
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
