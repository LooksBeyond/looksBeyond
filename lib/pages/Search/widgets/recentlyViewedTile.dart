import 'package:flutter/material.dart';
import 'package:looksbeyond/models/clients.dart';

class RecentlyViewedSearch extends StatelessWidget {
  final Client client;
  const RecentlyViewedSearch(
      {super.key,
      required this.client,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(client.name),
      subtitle: Text(client.address),
      leading: CircleAvatar(
        backgroundImage: AssetImage(client.imageUrl),
      ),
    );
  }
}
