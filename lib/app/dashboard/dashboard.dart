// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../../src/common_widgets/home appBar vendor name.dart';
import '../../src/common_widgets/home orders container.dart';
import '../../src/common_widgets/home showModalBottomSheet.dart';
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

//=================================== DROP DOWN BUTTON =====================================\\

  String dropDownItemValue = "Daily";

  void dropDownOnChanged(String? newValue) {
    setState(() {
      dropDownItemValue = newValue!;
    });
  }

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
        tooltip: "Add a product",
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
              child: GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const Profile(),
                  //   ),
                  // );
                },
                child: CircleAvatar(
                  minRadius: 20,
                  backgroundColor: kSecondaryColor,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/profile/profile-picture.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const AppBarVendor(
              vendorName: "Ntachi-Osa",
              vendorLocation: "Independence Layout, Enugu",
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: 20,
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const Notifications(),
              //   ),
              // );
            },
            splashRadius: 20,
            icon: Icon(
              Icons.notifications_outlined,
              color: kAccentColor,
            ),
          ),
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
