import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looksbeyond/models/user_booking.dart';

class PaymentScreen extends StatefulWidget {
  static const String pageName = "/paymentScreen";
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Map<String, dynamic> arguments;
  late DocumentSnapshot employee;
  late DocumentSnapshot service;
  late DocumentSnapshot brand;
  late UserBooking userBooking;
  late double totalTaxes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    employee = arguments["employee"];
    service = arguments["service"];
    userBooking = arguments["userBooking"];
    brand = arguments["brand"];
    totalTaxes = userBooking.subtotal * 0.13;


    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.white,
                elevation: 0.5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: 270,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the value as needed
                        child: Image.network(
                          brand['logo'],
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userBooking.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            brand['brand'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Subtotal: \$ "+userBooking.subtotal.toString()),
                              Text("Taxes: \$ "+ totalTaxes.toStringAsFixed(2)),
                              Text("Total: \$ "+(userBooking.subtotal + totalTaxes).toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text("Payment Options", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
              SizedBox(height: 10,),
              if(!Platform.isAndroid)
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/img/applePay.png', height: 35,),
                    title: Text(
                      'Apple Pay',
                      style: TextStyle(color: Colors.black), // Change text color to white
                    ),
                  ),
                ),
              Container(
                padding: EdgeInsets.all(5),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Image.asset('assets/img/googlePay.png', height: 35,),
                  title: Text(
                    'Google Pay',
                    style: TextStyle(color: Colors.black), // Change text color to white
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // Payment details input fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Use Credit Card", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Expiration Date'),
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 32.0),
                  // Button to initiate payment
                  Container(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      child: Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    // Implement payment processing logic here
  }
}
