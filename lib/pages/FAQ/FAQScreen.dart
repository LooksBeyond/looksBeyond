import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/pages/FAQ/widgets/FAQItem.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('faqs').get(),
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

            List<FAQItem> faqItems = snapshot.data!.docs.map((doc) => FAQItem(
              question: doc['question'],
              answer: doc['answer'],
            )).toList();

            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              children: faqItems,
            );
          },
        ),
      ),
    );
  }
}
