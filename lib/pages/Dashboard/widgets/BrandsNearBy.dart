import 'package:flutter/material.dart';
import 'package:looksbeyond/models/clients.dart';

class BrandsNearBy extends StatefulWidget {
  final Client client;
  const BrandsNearBy({super.key, required this.client});

  @override
  State<BrandsNearBy> createState() => _BrandsNearByState();
}

class _BrandsNearByState extends State<BrandsNearBy> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
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
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.client.name, style: TextStyle(decoration: TextDecoration.underline),),
                    Text(widget.client.address, style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
