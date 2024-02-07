import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class SquadPaymentWidget extends StatefulWidget {
  final String apiKey;
  final Map? metaData;
  final String email;
  final String customerName;
  final String currency;
  final String amount;
  final Function() onTransaction;
  final Function()? onClose;
  const SquadPaymentWidget({
    super.key,
    required this.apiKey,
    this.metaData,
    required this.email,
    this.customerName = '',
    this.currency = 'NGN',
    required this.amount,
    required this.onTransaction,
    this.onClose,
  });

  @override
  SquadPaymentWidgetState createState() => SquadPaymentWidgetState();
}

class SquadPaymentWidgetState extends State<SquadPaymentWidget> {
  late WebViewXController webviewController;
  String html = "";
  @override
  void initState() {
    super.initState();

    String metaData =
        widget.metaData == null ? 'null' : jsonEncode(widget.metaData);
    String apiKey = '"${widget.apiKey}"';
    String email = '"${widget.email}"';
    String customerName = '"${widget.customerName}"';
    String currency = '"${widget.currency}"';
    String amount = widget.amount;

    html = """
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0">
    </head>

    <body>
      <!-- <button onclick="SquadPay()"> Pay with Alatpay </button> -->

    <script src="https://checkout.squadco.com/widget/squad.min.js"></script> 
    <script>
    function SquadPay() {
    
      const squadInstance = new squad({
        onClose: () => paymentcancel("payment closed"),
        onLoad: () => console.log("Widget loaded successfully"),
        onSuccess: () => paymentsuccess("payment success"),
        key: $apiKey,
        //Change key (test_pk_sample-public-key-1) to the key on your Squad Dashboard
        email: $email,
        amount: $amount * 100,
        //Enter amount in Naira or Dollar (Base value Kobo/cent already multiplied by 100)
        currency_code: $currency,
        customer_name: $customerName,
        metadata: $metaData
      });
      squadInstance.setup();
      squadInstance.open();

    }
    SquadPay()

    </script>
    </body>

    </html>
    """;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      // Look here!
      child: WebViewX(
          dartCallBacks: <DartCallback>{
            DartCallback(
              name: 'paymentsuccess',
              callBack: (message) {
                widget.onTransaction();
              },
            ),
            DartCallback(
              name: 'paymentcancel',
              callBack: (message) {
                if (widget.onClose == null) {
                  Navigator.pop(context);
                } else {
                  widget.onClose!();
                }
              },
            ),
          },
          width: media.width,
          height: media.height,
          initialContent: html,
          initialSourceType: SourceType.html,
          onWebViewCreated: (controller) {
            webviewController = controller;
          }),
    ));
  }
}
