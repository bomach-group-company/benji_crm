import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/components/section/bank_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import '../../../theme/colors.dart';
import '../../controller/withdraw_controller.dart';
import '../../src/providers/constants.dart';

class SelectBank extends StatefulWidget {
  const SelectBank({super.key});

  @override
  State<SelectBank> createState() => _SelectBankState();
}

class _SelectBankState extends State<SelectBank> {
  @override
  void initState() {
    // WithdrawController.instance.listBanks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    selectedBankName.dispose();
  }

  //==================  CONTROLLERS ==================\\
  final scrollController = ScrollController();
  final bankQueryEC = TextEditingController();

  //================== ALL VARIABLES ==================\\
  final selectedBankName = ValueNotifier<String?>(null);
  final selectedBankCode = ValueNotifier<String?>(null);

  //================== BOOL VALUES ==================\\
  bool isTyping = false;
  bool refreshing = false;

  //================== FUNCTIONS ==================\\

  selectBank(index) async {
    final newBankName = WithdrawController.instance.listOfBanks[index].name;
    final newBankCode = WithdrawController.instance.listOfBanks[index].code;

    selectedBankName.value = newBankName;
    selectedBankCode.value = newBankCode;

    bankQueryEC.text = newBankName;

    final result = {'name': newBankName, 'code': newBankCode};

    Get.back(result: result);
  }

  Future<void> handleRefresh() async {
    await WithdrawController.instance.listBanks();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        appBar: MyAppBar(
          title: "Select a bank",
          elevation: 0,
          actions: const [],
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: RefreshIndicator(
          onRefresh: handleRefresh,
          child: SafeArea(
            child: Scrollbar(
              child: GetBuilder<WithdrawController>(
                // initState: (state) => WithdrawController.instance.listBanks(),
                builder: (controller) {
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    controller: scrollController,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(10),
                      //   child: SearchBar(
                      //     controller: bankQueryEC,
                      //     hintText: "Search bank",
                      //     backgroundColor: MaterialStatePropertyAll(
                      //         Theme.of(context).scaffoldBackgroundColor),
                      //     elevation: const MaterialStatePropertyAll(0),
                      //     leading: FaIcon(
                      //       FontAwesomeIcons.magnifyingGlass,
                      //       color: kAccentColor,
                      //       size: 20,
                      //     ),
                      //     // onChanged: onChanged,
                      //     padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
                      //     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     )),
                      //     side:
                      //         MaterialStatePropertyAll(BorderSide(color: kLightGreyColor)),
                      //   ),
                      // ),

                      controller.listOfBanks.isEmpty || controller.isLoad.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: kAccentColor,
                              ),
                            )
                          : controller.listOfBanks.isEmpty
                              ? const EmptyCard(
                                  emptyCardMessage:
                                      "There are no controller listed right now",
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.listOfBanks.length,
                                  separatorBuilder: (context, index) =>
                                      kSizedBox,
                                  itemBuilder: (context, index) {
                                    final bankName =
                                        controller.listOfBanks[index].name;
                                    // Check if the bankName contains the search query
                                    if (bankName.toLowerCase().contains(
                                        bankQueryEC.text.toLowerCase())) {
                                      return BankListTile(
                                        onTap: () => selectBank(index),
                                        bank: bankName,
                                      );
                                    } else {
                                      // Return an empty container for controller that do not match the search
                                      return Container();
                                    }
                                  },
                                ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
