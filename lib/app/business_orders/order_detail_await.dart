import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/order_status_change.dart';
import 'package:benji_aggregator/model/business_order_model.dart';
import 'package:benji_aggregator/model/third_party_vendor_model.dart';
import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/button/my_elevatedButton.dart';
import 'package:benji_aggregator/src/components/image/my_image.dart';
import 'package:benji_aggregator/src/components/input/my_item_drop_down_menu.dart';
import 'package:benji_aggregator/src/components/input/my_textformfield.dart';
import 'package:benji_aggregator/src/utils/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class OrderDetailsAwait extends StatefulWidget {
  final BusinessOrderModel order;
  final ThirdPartyVendorModel vendor;

  const OrderDetailsAwait(
      {super.key, required this.order, required this.vendor});

  @override
  State<OrderDetailsAwait> createState() => _OrderDetailsAwaitState();
}

class _OrderDetailsAwaitState extends State<OrderDetailsAwait> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    OrderStatusChangeController.instance.closeTaskSocket();
    super.dispose();
  }

//============================== ALL VARIABLES ================================\\
  final formKey = GlobalKey<FormState>();

  bool rejectStatus = false;
  final rejectController = TextEditingController();
  final rejectSelectController = TextEditingController();
  var rejectFN = FocusNode();
  bool show2ndInput = false;

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
    return GetBuilder<OrderController>(builder: (controller) {
      return Scaffold(
        appBar: MyAppBar(
          title: "Confirm Items",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
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
                          widget.order.created,
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
                          widget.order.code,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.32,
                          ),
                        ),
                        Text(
                          status[widget.order.deliveryStatus.toLowerCase()] ??
                              "",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: statusColor[widget.order.deliveryStatus
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
                    itemCount: widget.order.orderitems.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var adjustedIndex = index + 1;
                      var order = widget.order.orderitems[index];
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
                          url: widget.order.client.image,
                        ),
                      ),
                      kWidthSizedBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.order.client.firstName} ${widget.order.client.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          kHalfSizedBox,
                          Text(
                            widget.order.client.phone,
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
                                  widget.order.preTotal.toString()),
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
            kSizedBox,
            kSizedBox,
            Column(
              children: [
                MyElevatedButton(
                  title: "Confirm",
                  onPressed: () => controller.confirmOrder(widget.order.id),
                  disable: controller.isLoadAwaitConfirm.value,
                ),
                kSizedBox,
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        rejectStatus
                            ? Column(
                                children: [
                                  ItemDropDownMenu(
                                      onSelected: (value) {
                                        if (value!.toString() ==
                                            'Item not available') {
                                          setState(() {
                                            show2ndInput = true;
                                          });
                                        } else {
                                          setState(() {
                                            show2ndInput = false;
                                            rejectController.text =
                                                rejectSelectController.text;
                                          });
                                        }
                                      },
                                      itemEC: rejectSelectController,
                                      hintText: "Reason",
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(
                                          value: 'Not Open',
                                          label: 'Not Open',
                                        ),
                                        DropdownMenuEntry(
                                          value: 'Item not available',
                                          label: 'Item not available',
                                        ),
                                      ]),
                                  show2ndInput
                                      ? Column(
                                          children: [
                                            kSizedBox,
                                            MyTextFormField(
                                                controller: rejectController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value == "") {
                                                    return "Which items";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  rejectController.text =
                                                      rejectSelectController
                                                              .text +
                                                          value;
                                                },
                                                textInputAction:
                                                    TextInputAction.done,
                                                focusNode: rejectFN,
                                                hintText: "Name of item(s)",
                                                textInputType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences),
                                          ],
                                        )
                                      : const SizedBox(),
                                  kSizedBox,
                                ],
                              )
                            : const SizedBox(),
                        MyElevatedButton(
                          color: rejectStatus ? kBlackColor : kGreyColor,
                          title: "Reject",
                          onPressed: () {
                            if (rejectStatus) {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                controller.confirmOrder(widget.order.id,
                                    confirm: false,
                                    reason: rejectController.text);
                              }
                            } else {
                              setState(() {
                                rejectStatus = true;
                              });
                            }
                          },
                          disable: controller.isLoadAwaitConfirm.value,
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
      );
    });
  }
}
