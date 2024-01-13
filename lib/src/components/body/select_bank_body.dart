import 'package:benji_aggregator/controller/withdraw_controller.dart';
import 'package:benji_aggregator/src/components/card/empty.dart';
import 'package:benji_aggregator/src/components/section/bank_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../providers/constants.dart';

class SelectBankBody extends StatefulWidget {
  final banks = Get.put(WithdrawController());

  SelectBankBody({super.key});

  @override
  State<SelectBankBody> createState() => _SelectBankBodyState();
}

class _SelectBankBodyState extends State<SelectBankBody> {
  @override
  void initState() {
    isTyping = false;

    super.initState();
  }

  @override
  void dispose() {
    selectedBankName.dispose();
    super.dispose();
  }

  //==================  CONTROLLERS ==================\\
  final scrollController = ScrollController();
  final bankQueryEC = TextEditingController();

  //================== ALL VARIABLES ==================\\
  final selectedBankName = ValueNotifier<String?>(null);
  final selectedBankCode = ValueNotifier<String?>(null);

  //================== BOOL VALUES ==================\\
  bool? isTyping;

  //================== FUNCTIONS ==================\\

  selectBank(index) async {
    final newBankName =
        WithdrawController.instance.listOfBankDetail[index].name;
    final newBankCode =
        WithdrawController.instance.listOfBankDetail[index].code;

    selectedBankName.value = newBankName;
    selectedBankCode.value = newBankCode;

    bankQueryEC.text = newBankName;

    final result = {'name': newBankName, 'code': newBankCode};

    Get.back(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
          //     onChanged: onChanged,
          //     padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
          //     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     )),
          //     side:
          //         MaterialStatePropertyAll(BorderSide(color: kLightGreyColor)),
          //   ),
          // ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: GetBuilder<WithdrawController>(
                  initState: (state) => WithdrawController.instance.listBanks(),
                  builder: (banks) {
                    return banks.listOfBankDetail.isEmpty
                        ? const EmptyCard()
                        // : banks.listOfBankDetail.isEmpty && banks.isLoad.value
                        //     ? Center(
                        //         child:
                        //             CircularProgressIndicator(color: kAccentColor),
                        //       )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemCount: banks.listOfBankDetail.length,
                            separatorBuilder: (context, index) => kSizedBox,
                            itemBuilder: (context, index) {
                              final bankName =
                                  banks.listOfBankDetail[index].name;
                              // Check if the bankName contains the search query
                              if (bankName
                                  .toLowerCase()
                                  .contains(bankQueryEC.text.toLowerCase())) {
                                return BankListTile(
                                  onTap: () => selectBank(index),
                                  bank: bankName,
                                );
                              } else {
                                // Return an empty container for banks that do not match the search
                                return Container();
                              }
                              // BankListTile(
                              //   onTap: () => selectBank(index),
                              //   bank: banks.listOfBankDetail[index].name,
                              // );
                            });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
