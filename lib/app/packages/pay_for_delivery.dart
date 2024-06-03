// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:io';
import 'dart:math';

import 'package:benji_aggregator/app/packages/packages.dart';
import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/payment_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/payment/monnify.dart';
import 'package:benji_aggregator/src/components/payment/monnify_mobile.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/src/utils/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../theme/colors.dart';

class PayForDelivery extends StatefulWidget {
  final String packageId,
      senderName,
      senderPhoneNumber,
      receiverName,
      receiverPhoneNumber,
      receiverLocation,
      itemName,
      itemQuantity,
      itemWeight,
      itemCategory,
      itemValue;

  const PayForDelivery({
    super.key,
    required this.packageId,
    required this.senderName,
    required this.senderPhoneNumber,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.receiverLocation,
    required this.itemName,
    required this.itemQuantity,
    required this.itemWeight,
    required this.itemValue,
    required this.itemCategory,
  });

  @override
  State<PayForDelivery> createState() => _PayForDeliveryState();
}

class _PayForDeliveryState extends State<PayForDelivery> {
  //=================================== INITIAL STATE ==========================================\\
  @override
  void initState() {
    super.initState();
    getTotalPrice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callGetDeliveryFee();
    });
    packageData = <String>[
      widget.senderName,
      "$countryDialCode ${widget.senderPhoneNumber}",
      widget.receiverName,
      "$countryDialCode ${widget.receiverPhoneNumber}",
      widget.receiverLocation,
      widget.itemName,
      widget.itemWeight,
      widget.itemCategory,
      widget.itemQuantity,
      "₦ ${widget.itemValue}"
    ];
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
  //=================================== ALL VARIABLES ==========================================\\

  // Map? _data;
  String countryDialCode = '+234';
  final double subTotal = 0;
  double totalPrice = 0;
  double deliveryFee =
      (PaymentController.instance.responseObject['details'] ?? {})
              .containsKey('delivery_fee')
          ? PaymentController.instance.responseObject['details']['delivery_fee']
          : 0.0;

  final String paymentDescription = "Benji app delivery";
  final String currency = "NGN";

  // double insuranceFee = 0;
  // double discountFee = 0;
  getTotalPrice() {
    totalPrice = subTotal + deliveryFee;
  }

  final List<String> titles = <String>[
    "Sender's name",
    "Sender's phone number",
    "Receiver's name",
    "Receiver's phone number",
    "Receiver's location",
    "Item name",
    "Item weight",
    "Item category",
    "Item quantity",
    "Item value",
  ];
  List<String>? packageData;

  //===================== GlobalKeys =======================\\

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //===================== CONTROLLERS =======================\\

  final scrollController = ScrollController();

  //===================== BOOL VALUES =======================\\

  //===================== FUNCTIONS =======================\\
  void toPackages() => Get.off(
        () => const Packages(),
        routeName: 'Packages',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  Future<void> callGetDeliveryFee() async {
    await PaymentController.instance.getDeliveryFee(widget.packageId);
  }

//======== Place Order =======\\
  void placeOrder() {
    String apiKey = monnifyAPIkey;
    String contractCode = contractCodeKey;
    String email = UserController.instance.user.value.email;
    String phone = UserController.instance.user.value.phone;
    String firstName = UserController.instance.user.value.firstName;
    String lastName = UserController.instance.user.value.lastName;
    String currency = 'NGN';
    String amount = (deliveryFee).ceil().toString();
    Map meta = {
      "the_item_id": widget.packageId,
      'the_item_type': 'package',
      "client_id": UserController.instance.user.value.id
    };
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          if (kIsWeb) {
            return MonnifyWidget(
              apiKey: apiKey,
              contractCode: contractCode,
              email: email,
              phone: phone,
              firstName: firstName,
              lastName: lastName,
              currency: currency,
              amount: amount,
              metaData: meta,
              onTransaction: (response) async {
                // print('the response from my monnify $response');
                if (response != null && response['status'] == "SUCCESS") {
                  await Future.delayed(const Duration(seconds: 1));
                  toPackages();
                }
              },
              onClose: () {
                Get.back();
              },
            );
          } else {
            return MonnifyWidgetMobile(
              apiKey: apiKey,
              contractCode: contractCode,
              email: email,
              phone: phone,
              firstName: firstName,
              lastName: lastName,
              currency: currency,
              amount: amount,
              metaData: meta,
              onTransaction: (response) async {
                print('the response from my monnify $response');
                if (response != null && response['status'] == "SUCCESS") {
                  await Future.delayed(const Duration(seconds: 1));
                  toPackages();
                }
              },
              onClose: () {
                Get.back();
              },
            );
          }
        }),
      );
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      print(e.toString());
    }
  }

  String generateRandomString(int len) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(
          title: "Payout",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: Container(
          width: media.width,
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(color: kPrimaryColor),
          child: MyElevatedButton(
            title: "Pay - ₦${doubleFormattedText(totalPrice)}",
            onPressed: placeOrder,
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              controller: scrollController,
              children: [
                Lottie.asset(
                  "assets/animations/delivery/frame_2.json",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                ),
                kSizedBox,
                const Text(
                  'Package Summary',
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                kSizedBox,
                Container(
                  width: media.width,
                  decoration: ShapeDecoration(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 24,
                        offset: Offset(0, 4),
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: titles.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(height: 1, color: kGreyColor1),
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: media.width - 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: kLightGreyColor),
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: media.width - 250,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          packageData![index],
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 12,
                            fontFamily: 'sen',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  width: media.width,
                  padding: const EdgeInsets.all(kDefaultPadding),
                  decoration: ShapeDecoration(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 24,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          'Payment Summary',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      kSizedBox,
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery Fee',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '₦${doubleFormattedText(deliveryFee)}',
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 16,
                                  fontFamily: 'Sen',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          kSizedBox,
                        ],
                      ),
                      kHalfSizedBox,
                      const Divider(height: 4, color: kGreyColor1),
                      kHalfSizedBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '₦${doubleFormattedText(totalPrice)}',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16,
                              fontFamily: 'Sen',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
