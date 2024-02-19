// // ignore_for_file: unused_local_variable

// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:webviewx/webviewx.dart';

// class MonnifyWidget extends StatefulWidget {
//   final String apiKey;
//   final String contractCode;
//   final Map? metaData;
//   final String email;
//   final String phone;
//   final String firstName;
//   final String lastName;
//   final String currency;
//   final String amount;
//   final Function(dynamic response) onTransaction;
//   final Function()? onClose;
//   const MonnifyWidget({
//     super.key,
//     required this.apiKey,
//     required this.contractCode,
//     this.metaData,
//     required this.email,
//     this.phone = '',
//     this.firstName = '',
//     this.lastName = '',
//     this.currency = 'NGN',
//     required this.amount,
//     required this.onTransaction,
//     this.onClose,
//   });

//   @override
//   MonnifyWidgetState createState() => MonnifyWidgetState();
// }

// class MonnifyWidgetState extends State<MonnifyWidget> {
//   late WebViewXController webviewController;
//   String html = "";
//   @override
//   void initState() {
//     super.initState();

//     String metaData =
//         widget.metaData == null ? 'null' : jsonEncode(widget.metaData);
//     String apiKey = '"${widget.apiKey}"';
//     String contractCode = '"${widget.contractCode}"';
//     String email = '"${widget.email}"';
//     String phone = '"${widget.phone}"';
//     String fullname = '"${widget.firstName} ${widget.lastName}"';
//     String currency = '"${widget.currency}"';
//     String amount = widget.amount;

//     html = """
// <html>
// <head>
//     <script type="text/javascript" src="https://sdk.monnify.com/plugin/monnify.js"></script>
//     <script>
//         function payWithMonnify() {
//             MonnifySDK.initialize({
//                 amount: $amount,
//                 currency: $currency,
//                 reference: new String((new Date()).getTime()),
//                 customerFullName: $fullname,
//                 customerEmail: $email,
//                 apiKey: $apiKey,
//                 contractCode: $contractCode,
//                 paymentDescription: "Order Payment",
//                 metadata: $metaData,
//                 incomeSplitConfig: [],
//                 onLoadStart: () => {
//                     console.log("loading has started");
//                 },
//                 onLoadComplete: () => {
//                     console.log("SDK is UP");
//                 },
//                 onComplete: function(response) {
//                     //Implement what happens when the transaction is completed.
//                     console.log(response);
//                     paymentsuccess(JSON.stringify(response));
//                 },
//                 onClose: function(data) {
//                     //Implement what should happen when the modal is closed here
//                     console.log(data);
//                     paymentcancel("payment cancel");
//                 }
//             });
//         }
//         payWithMonnify();
//     </script>
// </head>
// <body>
//      <!-- <div>
//         <button type="button" onclick="payWithMonnify()">Pay With Monnify</button>
//     </div> -->
// </body>
// </html>
// """;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context).size;
//     return Scaffold(
//         body: Center(
//       // Look here!
//       child: WebViewX(
//           dartCallBacks: <DartCallback>{
//             DartCallback(
//               name: 'paymentsuccess',
//               callBack: (message) {
//                 log('message success gotten $message');
//                 dynamic resp = jsonDecode(message);
//                 log('the resp $resp');
//                 widget.onTransaction(resp);
//               },
//             ),
//             DartCallback(
//               name: 'paymentcancel',
//               callBack: (message) {
//                 if (widget.onClose == null) {
//                   Navigator.pop(context);
//                 } else {
//                   widget.onClose!();
//                 }
//               },
//             ),
//           },
//           width: media.width,
//           height: media.height,
//           initialContent: html,
//           initialSourceType: SourceType.html,
//           onWebViewCreated: (controller) {
//             webviewController = controller;
//           }),
//     ));
//   }
// }
