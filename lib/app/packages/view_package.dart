import 'dart:io';
import 'dart:math';

import 'package:benji_aggregator/app/assign/assign_rider.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/controller/package_controller.dart';
import 'package:benji_aggregator/controller/push_notifications_controller.dart';
import 'package:benji_aggregator/model/package/delivery_item.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'report_package.dart';

class ViewPackage extends StatefulWidget {
  final DeliveryItem deliveryItem;
  const ViewPackage({
    super.key,
    required this.deliveryItem,
  });

  @override
  State<ViewPackage> createState() => _ViewPackageState();
}

class _ViewPackageState extends State<ViewPackage> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    packageData = <String>[
      widget.deliveryItem.status[0].toUpperCase() +
          widget.deliveryItem.status.substring(1).toLowerCase(),
      widget.deliveryItem.senderName,
      widget.deliveryItem.senderPhoneNumber,
      widget.deliveryItem.receiverName,
      widget.deliveryItem.receiverPhoneNumber,
      widget.deliveryItem.dropOffAddress,
      widget.deliveryItem.itemName,
      (doubleFormattedText(widget.deliveryItem.itemQuantity.toDouble())),
      "${widget.deliveryItem.itemWeight.start} KG - ${widget.deliveryItem.itemWeight.end} KG",
      widget.deliveryItem.itemCategory.name,
      "₦ ${doubleFormattedText(widget.deliveryItem.itemValue.toDouble())}",
      // "₦ ${doubleFormattedText(widget.deliveryItem.prices)}",
    ];
  }

  @override
  void dispose() {
    MyPackageController.instance.closeTaskSocket();

    super.dispose();
  }

  //================================================= ALL VARIABLES =====================================================\\
  DateTime now = DateTime.now();
  final List<String> titles = <String>[
    "Status",
    "Sender's name",
    "Sender's phone number",
    "Receiver's name",
    "Receiver's phone number",
    "Receiver's location",
    "Item name",
    "Item quantity",
    "Item weight",
    "item category",
    "Item value",
    // "Price",
  ];

  List<String>? packageData;
  bool isDispatched = false;
  String dispatchMessage = "Your item has been dispatched";
  //=================================================  CONTROLLERS =====================================================\\
  final scrollController = ScrollController();
  final screenshotController = ScreenshotController();

  //=================================================  Navigation =====================================================\\
  void toReportPackage() => Get.to(
        () => ReportPackage(deliveryItem: widget.deliveryItem),
        routeName: 'ReportPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void sharePackage() {
    showModalBottomSheet(
      context: context,
      elevation: 20,
      barrierColor: kBlackColor.withOpacity(0.8),
      showDragHandle: true,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: min(520, 220)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kDefaultPadding),
        ),
      ),
      enableDrag: true,
      builder: (builder) => shareBottomSheet(),
    );
  }

  Future<Uint8List> generatePdf() async {
    // Create a PDF document
    final pdf = pw.Document();

    // Capture the screenshot
    final imageFile = await screenshotController.capture();

    // Convert the image data to bytes
    final imgData = Uint8List.fromList(imageFile!);

    // Create a MemoryImage from the bytes
    final pdfImage = pw.MemoryImage(imgData);

    // Add the image to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            height: 1000,
            width: 1000,
            child: pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.contain,
                alignment: pw.Alignment.center,
                height: 800,
                width: 800,
              ),
            ),
          );
        },
      ),
    );

    // Save the PDF as bytes
    final pdfBytes = await pdf.save();

    return pdfBytes;
  }

  Future<void> sharePDF() async {
    final pdfBytes = await generatePdf();
    final appDir = await getTemporaryDirectory();
    final pdfName = "Benji Delivery ${formatDateAndTime(now)}";
    final pdfPath = '${appDir.path}/$pdfName.pdf';
    await File(pdfPath).writeAsBytes(pdfBytes);

    // Share the PDF file using share_plus
    await Share.shareXFiles([XFile(pdfPath)]);
  }

  shareImage() async {
    final imageFile = await screenshotController.capture();

    if (imageFile != null) {
      final appDir = await getTemporaryDirectory();
      final fileName = "Benji Delivery ${formatDateAndTime(now)}";
      final filePath = '${appDir.path}/$fileName.png';

      // Write the image data to the file
      await File(filePath).writeAsBytes(imageFile);

      //Share the file on any platform
      await Share.shareXFiles([XFile(filePath)], text: 'Shared from Benji');
    }
  }

  //=================================================  Widgets =====================================================\\
  Widget shareBottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              onTap: sharePDF,
              title: Text(
                "Share PDF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(height: 1, color: kGreyColor2),
            ListTile(
              onTap: shareImage,
              title: Text(
                "Share Image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  itemDispatched() async {
    Map<String, dynamic> data = {
      "status": "dispatched",
    };

    var url =
        "${Api.baseUrl}${Api.dispatchPackage}?package_id=${widget.deliveryItem.id}&display_message=$dispatchMessage";
    consoleLog(url);
    consoleLog(data.toString());
    await FormController.instance.patchAuth(url, data, 'dispatchPackage');
    if (FormController.instance.status.toString().startsWith('2')) {
      await PushNotificationController.showNotification(
        title: "Success",
        body: dispatchMessage,
        summary: "Package Delivery",
        largeIcon: "asset://assets/icons/package.png",
      );
      setState(() {
        isDispatched = true;
      });
      await Future.delayed(const Duration(microseconds: 500), () {
        getDeliveryItemsByClientAndStatus('pending');
        getDeliveryItemsByClientAndStatus('dispatched');
        getDeliveryItemsByClientAndStatus('completed');
        Get.close(1);
      });
    }
  }

  void _toAssignRider(DeliveryItem package) => Get.to(
        () => AssignRiderMap(itemId: package.id, itemType: 'package'),
        routeName: 'AssignRiderMap',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: false,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "View Package",
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _toAssignRider(widget.deliveryItem),
            child: Text(
              'Assign rider',
              style: TextStyle(
                  color: kAccentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Scrollbar(
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              Center(
                child: Container(
                  height: deviceType(media.width) >= 2 ? 200 : 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: () {
                        if (widget.deliveryItem.status.toLowerCase() ==
                            "completed") {
                          return const AssetImage(
                              "assets/icons/package-success.png");
                        }
                        if (widget.deliveryItem.status.toLowerCase() ==
                            "dispatched") {
                          return const AssetImage(
                              "assets/icons/delivery_bike.png");
                        } else {
                          return const AssetImage(
                              "assets/icons/package-waiting.png");
                        }
                      }(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              kHalfSizedBox,
              Screenshot(
                controller: screenshotController,
                child: Card(
                  borderOnForeground: true,
                  elevation: 20,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            height: deviceType(media.width) >= 2 ? 60 : 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/logo/benji_full_logo.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Divider(color: kGreyColor2, height: 0),
                          ListView.separated(
                            itemCount: titles.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: 1,
                              color: kGreyColor2,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height:
                                    deviceType(media.width) >= 2 ? 200 : 100,
                                width: media.width / 3,
                                padding: const EdgeInsets.all(10),
                                decoration:
                                    BoxDecoration(color: kLightGreyColor),
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
                                width: media.width / 2,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  packageData![index],
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: () {
                                      if (widget.deliveryItem.status
                                              .toLowerCase() ==
                                          "completed") {
                                        return kSuccessColor;
                                      }
                                      if (widget.deliveryItem.status
                                              .toLowerCase() ==
                                          "dispatched") {
                                        return kSecondaryColor;
                                      } else {
                                        return kLoadingColor;
                                      }
                                    }(),
                                    fontSize: 12,
                                    fontFamily: 'sen',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(color: kGreyColor2, height: 0),
                          kSizedBox,
                          isDispatched == false &&
                                  widget.deliveryItem.status.toLowerCase() !=
                                      "pending"
                              ? Text(
                                  "Thanks for choosing our service",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              : const SizedBox(),
                          Text.rich(
                            softWrap: true,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Generated by ",
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "Ben",
                                  style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "ji",
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kSizedBox,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              kSizedBox,
              Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'secret code to confirm package: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.deliveryItem.code,
                        style: TextStyle(
                          color: kAccentColor,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kSizedBox,
              GetBuilder<MyPackageController>(
                initState: (state) => MyPackageController.instance
                    .getTaskItemSocket(widget.deliveryItem.id),
                builder: (controller) {
                  return controller.taskItemStatusUpdate.value.action
                      ? MyElevatedButton(
                          disable:
                              !controller.taskItemStatusUpdate.value.action,
                          title: controller.hasFetched.value
                              ? controller.taskItemStatusUpdate.value.buttonText
                              : "Loading...",
                          onPressed: controller.hasFetched.value
                              ? () {
                                  controller.updateTaskItemStatus(
                                      widget.deliveryItem.id);
                                }
                              : () {},
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () => toReportPackage(),
                              style: OutlinedButton.styleFrom(
                                elevation: 10,
                                enableFeedback: true,
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.all(kDefaultPadding),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidFlag,
                                    color: kAccentColor,
                                    size: 18,
                                  ),
                                  kWidthSizedBox,
                                  Center(
                                    child: Text(
                                      "Report",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kAccentColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kWidthSizedBox,
                            ElevatedButton(
                              onPressed: sharePackage,
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: kAccentColor,
                                padding: const EdgeInsets.all(kDefaultPadding),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.shareNodes,
                                    color: kPrimaryColor,
                                    size: 18,
                                  ),
                                  kWidthSizedBox,
                                  SizedBox(
                                    child: Text(
                                      "Share",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                },
              ),
              kSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
