import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:looksbeyond/models/brand.dart';
import 'package:looksbeyond/pages/CreateBooking/CreateBooking.dart';

class BrandDisplayScreen extends StatefulWidget {
  static const String pageName = '/brand_display_screen';
  const BrandDisplayScreen({Key? key}) : super(key: key);

  @override
  State<BrandDisplayScreen> createState() => _BrandDisplayScreenState();
}

class _BrandDisplayScreenState extends State<BrandDisplayScreen> {
  bool loading = true;
  late Brand brand;
  List<Map<String, dynamic>> services = []; // List to store services
  late StreamSubscription<QuerySnapshot> _serviceSubscription;
  bool showMale = true;
  bool showFemale = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  int initialTabBarIndex = 0;

  @override
  void dispose() {
    _serviceSubscription.cancel(); // Cancel the subscription
    super.dispose();
  }

  // Function to fetch services from Firebase
  void fetchServices() {
    _serviceSubscription = FirebaseFirestore.instance
        .collection('service')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List<Map<String, dynamic>> fetchedServices = [];
      for (DocumentSnapshot doc in querySnapshot.docs) {
        String serviceId = doc.id;
        FirebaseFirestore.instance
            .collection('employee')
            .where('services.$serviceId', isNotEqualTo: "")
            .get()
            .then((employeesSnapshot) {
          if (!mounted) return; // Check if the widget is still mounted
          if (employeesSnapshot.docs.isNotEmpty) {
            fetchedServices.add({
              'id': serviceId,
              'name': doc['name'], // Adjust field name as needed
            });
          }
          setState(() {
            services = fetchedServices;
            loading = false;
          });
        }).catchError((error) {
          print("Error fetching employees: $error");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final brand = arguments['brand'] as Brand;
    final serviceFromPage = arguments['service'] as DocumentSnapshot?;
    if (serviceFromPage == null) {
      initialTabBarIndex = 0;
    } else {
      final tabBarIndex = serviceFromPage.id;
      final index =
          services.indexWhere((service) => service['id'] == tabBarIndex);
      if (index != -1) {
        initialTabBarIndex = index;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(brand.name),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: brand
                          .imageUrl, // Use the imageUrl from the Brand object
                      height: 300,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "Owner: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      brand.owner,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Filter:",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                      tooltip: "Male",
                                      onPressed: () {
                                        setState(() {
                                          showMale = !showMale;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.male,
                                        color: showMale
                                            ? Colors.blue
                                            : Colors.grey,
                                        semanticLabel: "Male",
                                      )),
                                  IconButton(
                                    tooltip: "Female",
                                    onPressed: () {
                                      setState(() {
                                        showFemale = !showFemale;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.female,
                                      color:
                                          showFemale ? Colors.red : Colors.grey,
                                      semanticLabel: "Female",
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Address: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                brand.address,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                    if (services.isNotEmpty)
                      DefaultTabController(
                        length: services.length,
                        initialIndex: initialTabBarIndex,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              tabs: services
                                  .map((service) =>
                                      Tab(text: service['name'] as String))
                                  .toList(),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 410,
                              child: TabBarView(
                                children: services.map((service) {
                                  return ServiceEmployeesList(
                                    service: service,
                                    showMale: showMale,
                                    showFemale: showFemale,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (services.isEmpty)
                      Center(
                        child: Text('No services available'),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ServiceEmployeesList extends StatelessWidget {
  final Map<String, dynamic> service;
  final bool showMale;
  final bool showFemale;

  const ServiceEmployeesList({
    required this.service,
    required this.showMale,
    required this.showFemale,
  });

  @override
  Widget build(BuildContext context) {
    String serviceId = service['id'] as String; // Adjust field name as needed
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('employee')
          .where('services.$serviceId', isNotEqualTo: "")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No employees available for this service'),
          );
        }

        List<Widget> employeeTiles = snapshot.data!.docs
            .map((doc) => EmployeeTile(
                  employee: doc,
                  serviceId: serviceId,
                  showMale: showMale,
                  showFemale: showFemale,
                ))
            .toList();

        return ListView(
          children: employeeTiles,
        );
      },
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final QueryDocumentSnapshot employee;
  final String serviceId;
  final bool showMale;
  final bool showFemale;

  const EmployeeTile({
    required this.employee,
    required this.serviceId,
    required this.showMale,
    required this.showFemale,
  });

  @override
  Widget build(BuildContext context) {
    final gender = employee['gender'] as String;
    if ((showMale && gender == 'male') || (showFemale && gender == 'female')) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            CreateBooking.pageName,
            arguments: {'employee': employee, 'service': serviceId},
          );
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(employee['img']),
        ),
        title: Text(employee['name']),
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
            Text("(" + employee["numberOfRatings"].toString() + ")")
          ],
        ),
      );
    } else {
      return SizedBox(); // Return empty container if not matching filter
    }
  }
}
