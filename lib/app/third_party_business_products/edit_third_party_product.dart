// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/api_processor_controller.dart';
import '../../controller/form_controller.dart';
import '../../controller/product_controller.dart';
import '../../model/product_model.dart';
import '../../model/product_type_model.dart';
import '../../model/sub_category.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/components/input/my_dropdown_menu.dart';
import '../../src/components/input/my_textformfield.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class EditThirdPartyProduct extends StatefulWidget {
  final ProductModel product;
  const EditThirdPartyProduct({super.key, required this.product});

  @override
  State<EditThirdPartyProduct> createState() => _EditThirdPartyProductState();
}

class _EditThirdPartyProductState extends State<EditThirdPartyProduct> {
  @override
  void initState() {
    super.initState();
    isToggled = true;
    // productTypeEC.text = widget.product.name;
    subCategoryEC.text = widget.product.subCategory.name;

    // subCategoryEC.text = widget.product.subCategory.id;
    productNameEC.text = widget.product.name;
    productDescriptionEC.text = widget.product.description;
    productPriceEC.text = widget.product.price.toString();
    productQuantityEC.text = widget.product.quantityAvailable.toString();
    getSubCategories().then((value) {
      subCategory = value;
      setState(() {});
    });
    getProductType().then((value) {
      productType = value;
      setState(() {});
    });
  }
  //============================= ALL VARIABLES =====================================\\

  //===================== GLOBAL KEYS =======================\\
  final formKey = GlobalKey<FormState>();

  //================================== FOCUS NODES ====================================\\
  final productTypeFN = FocusNode();
  final productNameFN = FocusNode();
  final productDescriptionFN = FocusNode();
  final productPriceFN = FocusNode();
  final productQuantityFN = FocusNode();
  final productDiscountFN = FocusNode();

  //================================== CONTROLLERS ====================================\\
  final productNameEC = TextEditingController();
  final productDescriptionEC = TextEditingController();
  final productPriceEC = TextEditingController();
  final productQuantityEC = TextEditingController();
  final subCategoryEC = TextEditingController();
  final productTypeEC = TextEditingController();

  //================================== VALUES ====================================\\

  List<SubCategory>? subCategory;
  List<ProductTypeModel>? productType;

  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  // bool categorySelected = false;
  var isToggled;

  int? selectedCategory;

  //================================== FUNCTIONS ====================================\\
  Future<void> submit() async {
    // if (selectedImage == null && productImages!.isEmpty) {
    //   ApiProcessorController.errorSnack("Please select product images");
    // }
    if (subCategoryEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select a category");
    }
    Map<String, dynamic> data = {
      'name': productNameEC.text,
      'description': productDescriptionEC.text,
      'price': productPriceEC.text,
      'quantity_available': productQuantityEC.text,
      'sub_category_id': subCategoryEC.text,
    };

    log("This is the data : $data");
    // await FormController.instance.postAuthstream(
    //   Api.baseUrl + Api.changeProduct + widget.product.id,
    //   data,
    //   {'product_image': selectedImage},
    //   'editProduct',
    // );
    await FormController.instance.patchAuth(
      Api.baseUrl + Api.changeProduct + widget.product.id,
      {'data': jsonEncode(data)}, // Wrap 'data' in a Map
      // {'product_image': selectedImage},
      'editProduct',
    );
    if (FormController.instance.status.toString().startsWith('2')) {
      ProductController.instance.refreshData(widget.product.business.id);
      // await PushNotificationController.showNotification(
      //   title: "Success.",
      //   body: "${productNameEC.text} has been been successfully updated.",
      // );

      Get.close(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Edit Product",
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: const [],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: kPrimaryColor),
          child: GetBuilder<FormController>(
            init: FormController(),
            builder: (saving) {
              return MyElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    submit();
                  }
                },
                isLoading: saving.isLoad.value,
                title: "Save",
              );
            },
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'Product Type',
                    //   style: TextStyle(
                    //     color: kTextBlackColor,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w700,
                    //     letterSpacing: -0.32,
                    //   ),
                    // ),
                    // kHalfSizedBox,
                    // ItemDropDownMenu(
                    //   itemEC: productTypeEC,
                    //   hintText: "Choose product type",
                    //   dropdownMenuEntries: productType == null
                    //       ? [
                    //           const DropdownMenuEntry(
                    //             value: 'Loading...',
                    //             label: 'Loading...',
                    //             enabled: false,
                    //           )
                    //         ]
                    //       : productType!
                    //           .map((item) => DropdownMenuEntry(
                    //               value: item.id, label: item.name))
                    //           .toList(),
                    // ),

                    const Text(
                      'Product Category',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                    ),
                    kHalfSizedBox,
                    MyDropDownMenu(
                      controller: subCategoryEC,
                      hintText: widget.product.subCategory.name,
                      dropdownMenuEntries: subCategory == null
                          ? [
                              const DropdownMenuEntry(
                                value: 'Loading...',
                                label: 'Loading...',
                                enabled: false,
                              )
                            ]
                          : subCategory!
                              .map(
                                (item) => DropdownMenuEntry(
                                  value: item.id,
                                  label: item.name,
                                ),
                              )
                              .toList(),
                    ),
                    kSizedBox,
                    const Text(
                      'Product Name',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                    ),
                    kHalfSizedBox,
                    MyTextFormField(
                      controller: productNameEC,
                      focusNode: productNameFN,
                      hintText: "Enter the product name here",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          productNameFN.requestFocus();
                          return "Enter the product name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productNameEC.text = value!;
                      },
                    ),
                    kSizedBox,
                    const Text(
                      'Unit Price',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                    ),
                    kHalfSizedBox,
                    MyTextFormField(
                      controller: productPriceEC,
                      focusNode: productPriceFN,
                      hintText: "Enter the unit price here",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        const pricePattern = r'^\d+(\.\d{1,2})?$';
                        if (value == null || value!.isEmpty) {
                          productPriceFN.requestFocus();
                          return "Enter the unit price";
                        }

                        if (!RegExp(pricePattern).hasMatch(value)) {
                          return "Incorrect format for price eg. 550.50";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productPriceEC.text = value!;
                      },
                    ),
                    kSizedBox,
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                    ),
                    kHalfSizedBox,
                    MyTextFormField(
                      controller: productQuantityEC,
                      focusNode: productQuantityFN,
                      hintText: "Enter the quantity here",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        const quantityPattern = r'^[1-9]\d*$';

                        if (value == null || value!.isEmpty) {
                          productQuantityFN.requestFocus();
                          return "Enter the quantity";
                        }
                        if (!RegExp(quantityPattern).hasMatch(value)) {
                          return "Must be number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productQuantityEC.text = value!;
                      },
                    ),
                    kSizedBox,
                    const Text(
                      'Product Description',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.32,
                      ),
                    ),
                    kHalfSizedBox,
                    MyMessageTextFormField(
                      controller: productDescriptionEC,
                      focusNode: productDescriptionFN,
                      hintText: "Enter the description here",
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          productDescriptionFN.requestFocus();
                          return "Enter the product description";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productDescriptionEC.text = value!;
                      },
                    ),
                    kSizedBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
