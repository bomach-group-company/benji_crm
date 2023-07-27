// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../../src/common_widgets/home appBar aggregator.dart';
import '../../src/common_widgets/home orders container.dart';
import '../../src/common_widgets/home showModalBottomSheet.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom show search.dart';
import '../../theme/colors.dart';
import '../profile/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

typedef ModalContentBuilder = Widget Function(BuildContext);

class _DashboardState extends State<Dashboard> {
//=================================== ALL VARIABLES =====================================\\

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        titleSpacing: kDefaultPadding / 2,
        elevation: 0.0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: const ShapeDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/profile/avatar-image.jpg"),
                      fit: BoxFit.cover,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ),
            const AppBarAggregator(
              title: "Welcome,",
              aggregatorName: "Mishaal Erickson",
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(
              Icons.search_rounded,
              color: kGreyColor1,
              size: 30,
            ),
          ),
          Stack(
            children: [
              IconButton(
                iconSize: 20,
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const Notifications(),
                  //   ),
                  // );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: kAccentColor,
                  size: 30,
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: ShapeDecoration(
                    color: kAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "10+",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          kWidthSizedBox
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            Container(
              padding: const EdgeInsets.all(
                kDefaultPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrdersContainer(
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
            ),
            const SizedBox(
              height: kDefaultPadding * 2,
            ),
          ],
        ),
      ),
    );
  }
}
