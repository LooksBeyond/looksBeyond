import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/service.dart';

class EmployeeInfoScreen extends StatefulWidget {
  static const String pageName = "/employeeInfoScreen";
  const EmployeeInfoScreen({super.key});

  @override
  State<EmployeeInfoScreen> createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  late DocumentSnapshot employee;

  @override
  Widget build(BuildContext context) {
    employee = ModalRoute
        .of(context)!
        .settings
        .arguments as DocumentSnapshot;
    List<String> serviceIds = employee['services'].keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Cover image
                Container(
                  padding: EdgeInsets.only(bottom: 50),
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // Use CachedNetworkImage instead of NetworkImage
                      image: CachedNetworkImageProvider(employee['img']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Circular avatar
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 10),
                  child: CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      // Use CachedNetworkImage instead of NetworkImage
                      backgroundImage: CachedNetworkImageProvider(employee['img']),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              employee['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Brand: ABC Salon',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Services & Prices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Service>>(
              future: fetchServices(serviceIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    children: snapshot.data!.map((service) {
                      return ServiceTile(
                        serviceName: service.name,
                        price: '\$${employee['services'][service.id]}',
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Reviews & Ratings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('empId', isEqualTo: employee.id)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No reviews found'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var review = snapshot.data!.docs[index];
                    return ReviewTile(
                      reviewerName: review['userName'],
                      rating: review['rating'],
                      review: review['comment'],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<Service>> fetchServices(List<String> serviceIds) async {
    List<Service> services = [];
    for (String serviceId in serviceIds) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('service')
          .doc(serviceId)
          .get();
      if (doc.exists) {
        services.add(Service.fromFirestore(doc));
      }
    }
    return services;
  }
}

class ServiceTile extends StatelessWidget {
  final String serviceName;
  final String price;

  const ServiceTile({
    required this.serviceName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.1, // Add elevation for a shadow effect
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Customize price color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String review;

  const ReviewTile({
    required this.reviewerName,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1, // Add elevation for a shadow effect
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reviewerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '$rating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                review,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
