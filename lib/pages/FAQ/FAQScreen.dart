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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          FAQItem(
            question: 'How do I make a booking?',
            answer: 'To make a booking, simply navigate to the Bookings screen and follow the instructions provided.',
          ),
          FAQItem(
            question: 'Can I cancel my booking?',
            answer: 'Yes, you can cancel your booking by going to the Bookings screen and selecting the booking you want to cancel.',
          ),
          FAQItem(
            question: 'What payment methods do you accept?',
            answer: 'We accept various payment methods, including credit/debit cards, PayPal, and cash on delivery. You can choose your preferred payment method during the booking process.',
          ),
          FAQItem(
            question: 'Do you offer refunds?',
            answer: 'Refund policies vary depending on the service provider and the specific circumstances. Please refer to the terms and conditions provided during the booking process or contact customer support for assistance.',
          ),
          FAQItem(
            question: 'How can I contact customer support?',
            answer: 'You can contact customer support by phone at 1-800-123-4567 or via email at support@example.com. Our support team is available 24/7 to assist you with any questions or concerns.',
          ),
        ],
      ),
    );
  }
}
