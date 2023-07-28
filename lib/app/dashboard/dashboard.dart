// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../../src/common_widgets/dashboard appBar.dart';
import '../../src/common_widgets/dashboard orders container.dart';
import '../../src/common_widgets/dashboard rider_vendor container.dart';
import '../../src/common_widgets/dashboard showModalBottomSheet.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

typedef ModalContentBuilder = Widget Function(BuildContext);

class _DashboardState extends State<Dashboard> {
//=================================== ALL VARIABLES =====================================\\
  int incrementOrderID = 2 + 2;
  late int orderID;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = format12HrTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const AddProduct(),
          //   ),
          // );
        },
        elevation: 20.0,
        backgroundColor: kAccentColor,
        foregroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: const DashboardAppBar(),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrdersContainer(
                  containerColor: kPrimaryColor,
                  typeOfOrderColor: kTextGreyColor,
                  iconColor: kGreyColor1,
                  onTap: () {
                    OrdersContainerBottomSheet(
                      context,
                      "20 Running",
                      20,
                    );
                  },
                  numberOfOrders: "20",
                  typeOfOrders: "Active",
                ),
                OrdersContainer(
                  containerColor: Colors.red.shade100,
                  typeOfOrderColor: kAccentColor,
                  iconColor: kAccentColor,
                  onTap: () {
                    OrdersContainerBottomSheet(
                      context,
                      "5 Pending",
                      5,
                    );
                  },
                  numberOfOrders: "05",
                  typeOfOrders: "Pending",
                ),
              ],
            ),
            kSizedBox,
            RiderVendorContainer(
              onTap: () {},
              number: "390",
              typeOf: "Vendors",
              onlineStatus: "248 Online",
            ),
            kSizedBox,
            RiderVendorContainer(
              onTap: () {},
              number: "90",
              typeOf: "Riders",
              onlineStatus: "32 Online",
            ),
            const SizedBox(height: kDefaultPadding * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 200,
                  child: Text(
                    "New Orders",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 16,
                        color: kAccentColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
            kSizedBox,
            Column(
              children: [
                for (orderID = 1; orderID < 30; orderID += incrementOrderID)
                  Container(
                    // margin: const EdgeInsets.symmetric(
                    //   horizontal: kDefaultPadding / 2,
                    //   vertical: kDefaultPadding / 2,
                    // ),
                    padding: const EdgeInsets.only(
                      top: kDefaultPadding / 2,
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                    ),
                    width: mediaWidth / 1.1,
                    height: 140,
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/images/food/chizzy's-food.png",
                                  ),
                                ),
                              ),
                            ),
                            kHalfSizedBox,
                            Container(
                              child: Text(
                                "#00${orderID.toString()}",
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                        kWidthSizedBox,
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                width: mediaWidth / 1.55,
                                // color: kAccentColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: mediaWidth / 3,
                                      child: const Text(
                                        "Hot Kitchen",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mediaWidth / 8,
                                      child: Text(
                                        formattedTime,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
