import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/Dashboard/widgets/ServicesList.dart';


class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return SizedBox(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var category = snapshot.data!.docs[index];
              return GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(ServicesList.pageName, arguments: category.id);
                  },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(category['img']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 120,
                        child: Text(
                          category['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

