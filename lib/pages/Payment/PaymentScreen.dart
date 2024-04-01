import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:looksbeyond/models/user_booking.dart';
import 'package:looksbeyond/pages/Dashboard/dashboard.dart';
import 'package:pay/pay.dart' as pay;
import 'package:http/http.dart' as http;

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
  late String _applePaymentProfile;
  late String _googlePaymentProfile;

  @override
  void initState() {
    super.initState();
  }

  // "shippingMethods": [
  //       {
  //         "amount": ${userBooking.total.toString()},
  //         "detail": "${userBooking.title}",
  //         "identifier": "in_store_pickup",
  //         "label": "In-Store Pickup"
  //       },
  //       {
  //         "amount": "4.99",
  //         "detail": "5-8 Business Days",
  //         "identifier": "flat_rate_shipping_id_2",
  //         "label": "UPS Ground"
  //       },
  //       {
  //         "amount": "29.99",
  //         "detail": "1-3 Business Days",
  //         "identifier": "flat_rate_shipping_id_1",
  //         "label": "FedEx Priority Mail"
  //       }
  //     ]
  var _paymentItems = [
    pay.PaymentItem(
      label: 'Total',
      amount: '0.01',
      status: pay.PaymentItemStatus.final_price,
    )
  ];

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    employee = arguments["employee"];
    service = arguments["service"];
    userBooking = arguments["userBooking"];
    brand = arguments["brand"];
    totalTaxes = userBooking.subtotal * 0.13;

    _applePaymentProfile = """
{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.flutter.stripe.test",
    "displayName": "${userBooking.title}",
    "merchantCapabilities": ["3DS"],
    "supportedNetworks": [
      "amex",
      "visa",
      "discover",
      "masterCard"
    ],
    "countryCode": "CA",
    "currencyCode": "CAD"
  }
}
""";

    _googlePaymentProfile = """{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "stripe:version": "2020-08-27",
            "stripe:publishableKey": "pk_test_51P07Xc2KIHEg32T5BJYwWDLLfVQDFWC9FxDAoAHbIWbHtEfZPQZlribf77K8LyYjidoHfCRWBMs7xsM14WM0OGvP00vdw67vEa"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "LooksBeyond"
    },
    "transactionInfo": {
      "countryCode": "CA",
      "currencyCode": "CAD"
    }
  }
}""";

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
                        child: CachedNetworkImage(
                          imageUrl: brand['logo'],
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                              Text("Subtotal: \$ " +
                                  userBooking.subtotal.toString()),
                              Text(
                                  "Taxes: \$ " + totalTaxes.toStringAsFixed(2)),
                              Text(
                                "Total: \$ " +
                                    (userBooking.subtotal + totalTaxes)
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment Options",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              if (Platform.isIOS)
                // GestureDetector(
                //   onTap: () {
                //     _processPayment("Apple Pay", userBooking);
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(5),
                //     margin: EdgeInsets.only(bottom: 15),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.5),
                //           spreadRadius: 2,
                //           blurRadius: 7,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     child: ListTile(
                //       leading: Image.asset(
                //         'assets/img/applePay.png',
                //         height: 35,
                //       ),
                //       title: Text(
                //         'Apple Pay',
                //         style: TextStyle(
                //             color: Colors.black), // Change text color to white
                //       ),
                //     ),
                //   ),
                // ),
                pay.ApplePayButton(
                  type: pay.ApplePayButtonType.plain,
                  paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
                    _applePaymentProfile,
                  ),
                  paymentItems: _paymentItems,
                  height: pay.RawApplePayButton.minimumButtonHeight + 30,
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  onPaymentResult: onApplePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  // childOnError: Text('Apple Pay is not available in this device'),
                  onError: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'There was an error while trying to perform the payment'),
                      ),
                    );
                  },
                ),
              // GestureDetector(
              //   onTap: () {
              //     _processPayment("Google Pay", userBooking);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(5),
              //     margin: EdgeInsets.only(bottom: 15),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey.withOpacity(0.5),
              //           spreadRadius: 2,
              //           blurRadius: 7,
              //           offset: Offset(0, 3), // changes position of shadow
              //         ),
              //       ],
              //     ),
              //     child: ListTile(
              //       leading: Image.asset(
              //         'assets/img/googlePay.png',
              //         height: 35,
              //       ),
              //       title: Text(
              //         'Google Pay',
              //         style: TextStyle(
              //             color: Colors.black), // Change text color to white
              //       ),
              //     ),
              //   ),
              // ),
              pay.GooglePayButton(
                type: pay.GooglePayButtonType.plain,
                paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
                  _googlePaymentProfile,
                ),
                paymentItems: _paymentItems,
                margin: const EdgeInsets.only(top: 15),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
                onPressed: () async {
                  _processPayment("Google Pay", userBooking);
                },
                // childOnError: Text('Google Pay is not available in this device'),
                onError: (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'There was an error while trying to perform the payment'),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  _processPayment("Credit Card", userBooking);
                },
                child: Container(
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
                    leading: Icon(
                      Icons.credit_card,
                      size: 35,
                    ),
                    title: Text(
                      'Credit Card',
                      style: TextStyle(
                          color: Colors.black), // Change text color to white
                    ),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              child: Image.asset("assets/img/visa.png")),
                          Container(
                              width: 40,
                              child: Image.asset("assets/img/mastercard.png"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Payment details input fields
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Use Credit Card", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              //     TextFormField(
              //       decoration: InputDecoration(labelText: 'Card Number'),
              //       keyboardType: TextInputType.number,
              //     ),
              //     SizedBox(height: 16.0),
              //     TextFormField(
              //       decoration: InputDecoration(labelText: 'Expiration Date'),
              //       keyboardType: TextInputType.datetime,
              //     ),
              //     SizedBox(height: 16.0),
              //     TextFormField(
              //       decoration: InputDecoration(labelText: 'CVV'),
              //       keyboardType: TextInputType.number,
              //     ),
              //     SizedBox(height: 32.0),
              //     // Button to initiate payment
              //     Container(
              //       alignment: Alignment.bottomRight,
              //       child: ElevatedButton(
              //         onPressed: _processPayment,
              //         child: Text('Pay Now'),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      debugPrint(tokenJson.toString());

      final params = stripe.PaymentMethodParams.cardFromToken(
        paymentMethodData: stripe.PaymentMethodDataCardFromToken(
          token: tokenJson['id'], // TODO extract the actual token
        ),
      );

      // 3. Confirm Google pay payment method
      await stripe.Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google Pay payment succesfully completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _processPayment(String provider, UserBooking userBooking) {
    print("Payment button pressed, " + provider);

    // Create a map of booking data
    Map<String, dynamic> bookingData = {
      'title': userBooking.title,
      'userId': userBooking.userId,
      'dateTime': userBooking.dateTime,
      'status': userBooking.status.name,
      'brand': brand.id,
      'isPaid': true,
      'timeSlot': userBooking.timeSlot,
      'date': userBooking.date,
      'subtotal': userBooking.subtotal,
      'total': userBooking.subtotal + totalTaxes,
      'service': userBooking.service,
      'taxes': totalTaxes,
      'paidThrough': provider,
      'employee': employee.id,
      'empImage': employee['img'],
      'review': "",
    };

    FirebaseFirestore.instance
        .collection('bookings')
        .add(bookingData)
        .then((value) {
      print('Booking added successfully!');
    }).catchError((error) {
      print('Failed to add booking: $error');
    });

    Navigator.of(context)
        .popUntil(ModalRoute.withName(BottomNavBarScreen.pageName));
  }

  Future<void> onApplePayResult(paymentResult) async {
    try {
      //debugPrint(paymentResult.toString());
      // 1. Get Stripe token from payment result
      final token =
          await stripe.Stripe.instance.createApplePayToken(paymentResult);

      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];

      final params = stripe.PaymentMethodParams.cardFromToken(
        paymentMethodData: stripe.PaymentMethodDataCardFromToken(
          token: token.id,
        ),
      );

      // 3. Confirm Apple pay payment method
      await stripe.Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apple Pay payment succesfully completed'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    _processPayment("Apple Pay", userBooking);

  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('https://api.stripe.com/v1/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': 'example@gmail.com',
        'currency': 'usd',
        'items': ['id-1'],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }
}
