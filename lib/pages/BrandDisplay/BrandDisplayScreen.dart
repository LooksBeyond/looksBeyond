import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/brand.dart';

class BrandDisplayScreen extends StatefulWidget {
  static const String pageName = '/brand_display_screen';
  const BrandDisplayScreen({super.key});

  @override
  State<BrandDisplayScreen> createState() => _BrandDisplayScreenState();
}

class _BrandDisplayScreenState extends State<BrandDisplayScreen> {
  late Brand brand;
  late List employeeIds;
  @override
  Widget build(BuildContext context) {
    brand = ModalRoute.of(context)!.settings.arguments as Brand;
    employeeIds = List<String>.from(brand.employees);
    return Scaffold(
      appBar: AppBar(
        title: Text(brand.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                brand.imageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Employees",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('employee')
                    .where(FieldPath.documentId, whereIn: employeeIds)
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

                  List<Widget> employeeTiles = snapshot.data!.docs
                      .map((doc) => EmployeeTile(employee: doc))
                      .toList();

                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: employeeTiles,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final QueryDocumentSnapshot employee;

  const EmployeeTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(employee['img']),
      ),
      title: Text(employee['name']),
      subtitle: Text(employee['avgRating'].toString()),
    );
  }
}
