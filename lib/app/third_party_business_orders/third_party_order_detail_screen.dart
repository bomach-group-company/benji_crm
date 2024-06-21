// ignore_for_file: file_names

import 'package:benji_aggregator/controller/order_status_change.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/image/my_image.dart';
import '../../src/components/responsive_widgets/padding.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class ThirdPartyOrderDetails extends StatefulWidget {
  const ThirdPartyOrderDetails({super.key});

  @override
  State<ThirdPartyOrderDetails> createState() => _ThirdPartyOrderDetailsState();
}

class _ThirdPartyOrderDetailsState extends State<ThirdPartyOrderDetails> {
  @override
  void initState() {
    super.initState();
  }

//============================== ALL VARIABLES ================================\\

  final Map status = {
    'pend': 'PENDING',
    'comp': 'COMPLETED',
    'canc': 'CANCELLED',
    'dispatched': 'DISPATCHED',
    'received': 'INCOMING',
    'delivered': 'RECEIVED',
  };

  final Map statusColor = {
    'pend': kLoadingColor,
    'comp': kSuccessColor,
    'canc': kAccentColor.withOpacity(0.8),
    'dispatched': kBlueLinkTextColor,
    'received': kBlueLinkTextColor,
    'delivered': kAccentColor,
  };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyResponsivePadding(
      child: GetBuilder<OrderStatusChangeController>(
          initState: (state) =>
              OrderStatusChangeController.instance.getTaskItemSocket(),
          builder: (controller) {
            return Scaffold(
              appBar: MyAppBar(
                title: "Order Details",
                elevation: 0,
                actions: const [],
                backgroundColor: kPrimaryColor,
              ),
              bottomNavigationBar: Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: MyElevatedButton(
                    disable: !controller.taskItemStatusUpdate.value.action,
                    title: controller.hasFetched.value
                        ? controller.taskItemStatusUpdate.value.buttonText
                        : "Loading...",
                    onPressed: controller.hasFetched.value
                        ? controller.updateTaskItemStatus
                        : () {},
                    isLoading: controller.isLoadUpdateStatus.value,
                  )),
              body: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(kDefaultPadding),
                children: <Widget>[
                  Container(
                    width: media.width,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.30),
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
                    child: SizedBox(
                      width: media.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order ID',
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 11.62,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                OrderStatusChangeController
                                    .instance.order.value.created,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          kHalfSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                OrderStatusChangeController
                                    .instance.order.value.code,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.32,
                                ),
                              ),
                              Text(
                                status[controller.order.value.deliveryStatus
                                        .toLowerCase()] ??
                                    "",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: statusColor[controller
                                          .order.value.deliveryStatus
                                          .toLowerCase()] ??
                                      kSecondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.32,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  kSizedBox,
                  Container(
                    width: media.width,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.30),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Items ordered',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        ),
                        ListView.builder(
                          itemCount: OrderStatusChangeController
                              .instance.order.value.orderitems.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var adjustedIndex = index + 1;
                            var order = OrderStatusChangeController
                                .instance.order.value.orderitems[index];
                            return ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              horizontalTitleGap: 0,
                              leading: Text(
                                "$adjustedIndex.",
                                style: const TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              title: Text(
                                '${order.product.name} x ${order.quantity.toString()}',
                                style: const TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  kSizedBox,
                  Container(
                    width: media.width,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer's Detail",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        ),
                        kSizedBox,
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kLightGreyColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: MyImage(
                                url: OrderStatusChangeController
                                    .instance.order.value.client.image,
                              ),
                            ),
                            kWidthSizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${OrderStatusChangeController.instance.order.value.client.firstName} ${OrderStatusChangeController.instance.order.value.client.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                kHalfSizedBox,
                                Text(
                                  OrderStatusChangeController
                                      .instance.order.value.client.phone,
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                kHalfSizedBox,
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  kSizedBox,
                  Container(
                    width: media.width,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.30),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        ),
                        kSizedBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "₦ ",
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontFamily: 'Sen',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: convertToCurrency(
                                        OrderStatusChangeController
                                            .instance.order.value.preTotal
                                            .toString()),
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        kHalfSizedBox,
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
