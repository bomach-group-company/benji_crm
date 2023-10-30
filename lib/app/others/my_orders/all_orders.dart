import 'package:benji_aggregator/model/order.dart';
import 'package:benji_aggregator/src/components/my_appbar.dart';
import 'package:benji_aggregator/src/components/my_future_builder.dart';
import 'package:benji_aggregator/src/components/my_liquid_refresh.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../src/components/all_orders_container.dart';
import '../../../src/providers/constants.dart';

class AllCompletedOrders extends StatefulWidget {
  final List<Order> completed;

  const AllCompletedOrders({super.key, required this.completed});

  @override
  State<AllCompletedOrders> createState() => _AllCompletedOrdersState();
}

class _AllCompletedOrdersState extends State<AllCompletedOrders>
    with SingleTickerProviderStateMixin {
  //======================================= INITIAL AND DISPOSE ===============================================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\

  //=================================== Orders =======================================\\
  // final int _incrementOrderID = 2 + 2;
  // late int _orderID;
  final String _orderItem = "Jollof Rice and Chicken";
  final String _customerAddress = "21 Odogwu Street, New Haven";
  final int _itemQuantity = 2;
  // final double _price = 2500;
  final double _itemPrice = 2500;
  final String _orderImage = "chizzy's-food";
  final String _customerName = "Mercy Luke";

//===================== BOOL VALUES =======================\\
  // bool isLoading = false;
  late bool _loadingScreen;

  //=================================== CONTROLLERS ====================================\\

  final ScrollController scrollController = ScrollController();

  //=============================================== FUNCTIONS ====================================================\\
  double calculateSubtotal() {
    return _itemPrice * _itemQuantity;
  }

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      onRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "All Orders",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: MyFutureBuilder(
            future: null,
            child: () {
              return _loadingScreen
                  ? SpinKitDoubleBounce(color: kAccentColor)
                  : Scrollbar(
                      controller: scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        // controller: scrollController,
                        children: [
                          kSizedBox,
                          SizedBox(
                            width: media.width,
                            child: ListView.separated(
                                separatorBuilder: (context, index) => kSizedBox,
                                itemCount: widget.completed.length,
                                itemBuilder: (context, index) {
                                  Order completeOrder = widget.completed[index];

                                  return AllCompletedOrdersContainer(
                                    mediaWidth: media.width,
                                    orderImage: _orderImage,
                                    orderID: 123,
                                    orderStatusIcon: const Icon(
                                      Icons.check_circle,
                                      color: kSuccessColor,
                                    ),
                                    formattedDateAndTime: formattedDateAndTime,
                                    orderItem: _orderItem,
                                    itemQuantity: _itemQuantity,
                                    itemPrice: _itemPrice,
                                    customerName: _customerName,
                                    customerAddress: _customerAddress,
                                    order: completeOrder,
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
