import 'package:benji_aggregator/src/components/section/bank_list_tile.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/withdraw_controller.dart';

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
    WithdrawController.instance.listBanks();
    super.initState();
  }

  @override
  void dispose() {
    selectedBank.dispose();
    super.dispose();
  }

  //==================  CONTROLLERS ==================\\
  final scrollController = ScrollController();
  final bankQueryEC = TextEditingController();

  //================== ALL VARIABLES ==================\\
  final selectedBank = ValueNotifier<String?>(null);

  //================== BOOL VALUES ==================\\
  bool? isTyping;

  //================== FUNCTIONS ==================\\

  onChanged(value) async {
    setState(() {
      selectedBank.value = value;
      isTyping = true;
    });

    debugPrint("ONCHANGED VALUE: ${selectedBank.value}");
  }

  selectBank(index) async {
    final newBank = WithdrawController.instance.listOfBanks[index].name;
    selectedBank.value = newBank;

    setState(() {
      bankQueryEC.text = newBank;
    });

    debugPrint("Selected Bank: ${selectedBank.value}");
    debugPrint("New selected Bank: $newBank");
    debugPrint("Bank Query: ${bankQueryEC.text}");
    //Navigate to the previous page
    Get.back(result: newBank);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchBar(
              controller: bankQueryEC,
              hintText: "Search bank",
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).scaffoldBackgroundColor),
              elevation: const MaterialStatePropertyAll(0),
              leading: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: kAccentColor,
                size: 20,
              ),
              onChanged: onChanged,
              padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              side:
                  MaterialStatePropertyAll(BorderSide(color: kLightGreyColor)),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: GetBuilder<WithdrawController>(builder: (banks) {
                return banks.listOfBanks.isEmpty && banks.isLoad.value
                    ? Center(
                        child: CircularProgressIndicator(color: kAccentColor),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: banks.listOfBanks.length,
                        separatorBuilder: (context, index) => kSizedBox,
                        itemBuilder: (context, index) => BankListTile(
                          onTap: () => selectBank(index),
                          bank: banks.listOfBanks[index].name,
                          bankImage: banks.listOfBanks[index].logo,
                        ),
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
