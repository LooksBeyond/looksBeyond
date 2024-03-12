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
  late final TextEditingController _searchController;
  List<Brand> _filteredBrands = [];
  List<Brand> _allBrands = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
    _searchController = TextEditingController();
    _fetchBrands();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchBrands() async {
    final brandsSnapshot = await FirebaseFirestore.instance.collection('brands').get();
    setState(() {
      _allBrands = brandsSnapshot.docs.map((doc) => Brand.fromFirebase(doc)).toList();
      _filteredBrands = _allBrands;
    });
  }

  void _filterBrands(String query) {
    setState(() {
      _filteredBrands = _allBrands.where((brand) => brand.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search brands by name',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _filterBrands('');
              },
            ),
          ),
          onChanged: _filterBrands,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Brands',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBrands.length,
              itemBuilder: (context, index) {
                return RecentlyViewedSearch(client: _filteredBrands[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
