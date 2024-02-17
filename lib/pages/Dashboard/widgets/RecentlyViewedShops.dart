import 'package:flutter/material.dart';
import 'package:looksbeyond/models/clients.dart';

class RecentlyViewedDashboard extends StatefulWidget {
  final Client client;
  const RecentlyViewedDashboard({super.key, required this.client});

  @override
  State<RecentlyViewedDashboard> createState() =>
      _RecentlyViewedDashboardState();
}

class _RecentlyViewedDashboardState extends State<RecentlyViewedDashboard> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.client.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: isFav
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isFav = !isFav;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
