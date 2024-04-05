import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/ServiceBrands/ServiceBrands.dart';

class ServicesList extends StatefulWidget {
  static const String pageName = "./servicesList";
  const ServicesList({super.key});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {

  late String categoryId;
  late Stream<List<DocumentSnapshot>> _servicesStream;


  @override
  void initState() {
    super.initState();
  }

  Stream<List<DocumentSnapshot>> _getServicesStream(String categoryId) {
    return FirebaseFirestore.instance
        .collection('service')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }



  @override
  Widget build(BuildContext context) {
    categoryId = ModalRoute.of(context)!.settings.arguments as String;
    _servicesStream = _getServicesStream(categoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Services List'),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _servicesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<DocumentSnapshot>? services = snapshot.data;
          if (services == null || services.isEmpty) {
            return Center(child: Text('No services found.'));
          }
          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              DocumentSnapshot service = services[index];
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed(ServiceEmployees.pageName, arguments: service);
                },
                child: ListTile(
                  title: Text(service['name']),
                  trailing: Text(service['time'].toString() + " mins"),
                  // Add more fields as needed
                ),
              );
            },
          );
        },
      ),
    );
  }
}
