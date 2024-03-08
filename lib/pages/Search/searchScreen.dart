import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/brand.dart';
import 'package:looksbeyond/pages/Search/widgets/recentlyViewedTile.dart';


class SearchScreen extends StatefulWidget {
  static const String pageName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final FocusNode _searchFocusNode;

  List<Brand> ClientList = [
    // Brand(
    //   name: 'Client A',
    //   address: 'Address of Client A',
    //   imageUrl: 'assets/img/avatar.png',
    // ),
    // Brand(
    //   name: 'Client B',
    //   address: 'Address of Client B',
    //   imageUrl: 'assets/img/avatar.png',
    // ),
    // Brand(
    //   name: 'Client C',
    //   address: 'Address of Client C',
    //   imageUrl: 'assets/img/avatar.png',
    // ),
    // Brand(
    //   name: 'Client D',
    //   address: 'Address of Client D',
    //   imageUrl: 'assets/img/avatar.png',
    // ),
    // Brand(
    //   name: 'Client E',
    //   address: 'Address of Client E',
    //   imageUrl: 'assets/img/avatar.png',
    // ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusNode
        .dispose(); // Dispose the focus node when it's no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SearchBar(
        focusNode: _searchFocusNode,
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        trailing: [Icon(Icons.search)],
        elevation: MaterialStateProperty.all(0),
        hintText: "Search for services",
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recently Viewed Salons',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // List of recently viewed salons
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('brands').get(),
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

              List<Brand> brands = snapshot.data!.docs.map((doc) {
                return Brand.fromFirebase(doc);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: brands.length, // Number of recently viewed salons
                  itemBuilder: (context, index) {
                    // Replace this with your salon item widget
                    return RecentlyViewedSearch(client: brands[index]);
                  },
                ),
              );
            },
          ),


        ],
      ),
    );
  }
}
