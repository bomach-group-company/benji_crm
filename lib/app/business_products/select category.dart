// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/my_textformfield2.dart';
import '../../src/components/sheet/showModalBottomSheetTitleWithIcon.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../splash_screens/successful_screen.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  //======================================= ALL VARIABLES =======================================\\

  //================================== VALUES ====================================\\

  int? selectedCategory;

  //========================================= CONTROLLERS =========================================\\
  TextEditingController categoryNameEC = TextEditingController();

  //========================================= FOCUS NODES =========================================\\
  FocusNode categoryNameFN = FocusNode();

  //========================================= LISTS ==========================================\\

  int get categoryCount => categoryList.length;

  List<String> categoryList = [
    "Rice",
    "Swallow",
    "Soup",
    "Snacks",
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Select Category",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          children: [
            Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(
                kDefaultPadding,
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: categoryCount,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                          });
                        },
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categoryList[index],
                                style: TextStyle(
                                  color: selectedCategory == index
                                      ? kBlackColor
                                      : kGreyColor1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                selectedCategory == index
                                    ? Icons.check_rounded
                                    : null,
                                color: kAccentColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: kGreyColor1,
                        ),
                      ),
                      kSizedBox,
                    ],
                  );
                },
              ),
            ),
            MyElevatedButton(
              title: "Save",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SuccessfulScreen(
                      buttonAction: () {},
                      text: "Product added successfully",
                      elevatedButtonTitle: "Okay",
                    ),
                  ),
                );
              },
            ),
            kSizedBox,
            InkWell(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const AddCategory(),
                //   ),
                // );
                showModalBottomSheet(
                  context: context,
                  backgroundColor: kPrimaryColor,
                  barrierColor: kBlackColor.withOpacity(0.5),
                  showDragHandle: true,
                  useSafeArea: true,
                  isScrollControlled: true,
                  isDismissible: true,
                  elevation: 20.0,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    minHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(kDefaultPadding),
                    ),
                  ),
                  enableDrag: true,
                  builder: (context) => GestureDetector(
                    onTap: (() =>
                        FocusManager.instance.primaryFocus?.unfocus()),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(
                        left: kDefaultPadding,
                        top: kDefaultPadding / 2,
                        right: kDefaultPadding,
                        bottom: kDefaultPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShowModalBottomSheetTitleWithIcon(
                            title: "Create Category",
                          ),
                          const SizedBox(height: kDefaultPadding * 4),
                          MyTextFormField2(
                            controller: categoryNameEC,
                            focusNode: categoryNameFN,
                            textInputType: TextInputType.name,
                            hintText: "Enter category name here",
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              RegExp namePattern = RegExp(
                                r'^.{3,}$', //Less than 3 characters
                              );
                              if (value == null || value!.isEmpty) {
                                categoryNameFN.requestFocus();
                                return "Enter a category";
                              } else if (!namePattern.hasMatch(value)) {
                                categoryNameFN.requestFocus();
                                return "Please enter a valid name";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              categoryNameEC.text = value;
                            },
                          ),
                          kSizedBox,
                          MyElevatedButton(
                            title: "Save",
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SuccessfulScreen(
                                    buttonAction: () {},
                                    text: "Product created successfully",
                                    elevatedButtonTitle: "Okay",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 56,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0xFFE6E6E6),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outlined,
                      color: kAccentColor,
                    ),
                    kHalfWidthSizedBox,
                    Text(
                      'Add Category',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kAccentColor,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
