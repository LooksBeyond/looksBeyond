import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/brand.dart';
import 'package:looksbeyond/pages/BrandDisplay/BrandDisplayScreen.dart';

class BrandsNearBy extends StatefulWidget {
  final Brand brand;
  const BrandsNearBy({Key? key, required this.brand}) : super(key: key);

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
                    child: CachedNetworkImage(
                      imageUrl: widget.brand.imageUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  BrandDisplayScreen.pageName,
                  arguments: {
                    'brand': widget.brand,
                    'service': null,
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.brand.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.brand.address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
