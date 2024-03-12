import 'package:flutter/material.dart';
import 'package:looksbeyond/models/brand.dart';

class RecentlyViewedSearch extends StatelessWidget {
  final Brand client;
  const RecentlyViewedSearch(
      {super.key,
      required this.client,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(client.name),
      subtitle: Text(client.address),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(client.imageUrl),
      ),
    );
  }
}
