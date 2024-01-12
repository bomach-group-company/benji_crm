// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/form_controller.dart';
import 'package:benji_aggregator/model/product_type_model.dart';
import 'package:benji_aggregator/model/sub_category.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/src/components/input/my_dropdown_menu.dart';
import 'package:benji_aggregator/src/components/sheet/showModalBottomSheetTitleWithIcon.dart';
import 'package:benji_aggregator/src/responsive/responsive_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/my_vendor_model.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/components/input/my_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class AddProduct extends StatefulWidget {
  final MyVendorModel vendor;
  const AddProduct({super.key, required this.vendor});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  void initState() {
    super.initState();
    getSubCategories().then((value) {
      _subCategory = value;
      setState(() {});
    });
    getProductType().then((value) {
      _productType = value;
      setState(() {});
    });
  }
  //============================= ALL VARIABLES =====================================\\

  //===================== GLOBAL KEYS =======================\\
  final _formKey = GlobalKey<FormState>();

  //================================== DROP DOWN BUTTONFORMFIELD ====================================\\
  String dropDownItemValue = "Food";

  //================================== FOCUS NODES ====================================\\
  final productType = FocusNode();
  final productNameFN = FocusNode();
  final productDescriptionFN = FocusNode();
  final productPriceFN = FocusNode();
  final productQuantityFN = FocusNode();
  final productDiscountFN = FocusNode();

  void dropDownOnChanged(String? onChanged) {
    setState(() {
      dropDownItemValue = onChanged!;
    });
  }

  //================================== CONTROLLERS ====================================\\
  final scrollController = ScrollController();
  final productNameEC = TextEditingController();
  final productDescriptionEC = TextEditingController();
  final productPriceEC = TextEditingController();
  final productQuantityEC = TextEditingController();
  final productSubCategoryEC = TextEditingController();
  final productTypeEC = TextEditingController();

  //================================== VALUES ====================================\\

  List<SubCategory>? _subCategory;
  List<ProductTypeModel>? _productType;

  int? selectedCategory;

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  //================================== FUNCTIONS ====================================\\
  submit() async {
    if (selectedImage == null) {
      ApiProcessorController.errorSnack("Add product image(s)");
      return;
    }
    if (_productType!.isEmpty ||
        productTypeEC.text.isEmpty ||
        _productType == null) {
      ApiProcessorController.errorSnack("Select a product type");
      return;
    }
    if (_subCategory!.isEmpty ||
        productSubCategoryEC.text.isEmpty ||
        _subCategory == null) {
      ApiProcessorController.errorSnack("Select a category");
      return;
    }
    Map data = {
      'name': productNameEC.text,
      'description': productDescriptionEC.text,
      'price': productPriceEC.text,
      'quantity_available': productQuantityEC.text,
      'sub_category_id': productSubCategoryEC.text,
      'product_type': productTypeEC.text,
      'vendor_id': widget.vendor.id,
      'is_available': true,
      'is_recommended': true,
      'is_trending': true,
    };
    debugPrint("$data");
    await FormController.instance.postAuthstream(
        Api.baseUrl + Api.agentAddProductToVendor,
        data,
        {'product_image': selectedImage},
        'agentAddProductToVendor');
  }

  pickProductImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  //=========================== WIDGETS ====================================\\
  Widget uploadProductImage() {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: <Widget>[
          const ShowModalBottomSheetTitleWithIcon(
            title: "Upload Product Images",
          ),
          kSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickProductImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            width: 0.5,
                            color: kGreyColor1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          size: 18,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  const Text("Camera"),
                ],
              ),
              kWidthSizedBox,
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickProductImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            width: 0.5,
                            color: kGreyColor1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidImages,
                          size: 18,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  const Text("Gallery"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add New Item",
          backgroundColor: kPrimaryColor,
          elevation: 0.0,
          actions: const [],
        ),
        bottomNavigationBar: GetBuilder<FormController>(builder: (submitting) {
          return Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: MyElevatedButton(
              isLoading: submitting.isLoad.value,
              title: "Save",
              onPressed: (() async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  submit();
                }
              }),
            ),
          );
        }),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              padding: const EdgeInsets.all(kDefaultPadding),
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            elevation: 20,
                            barrierColor: kBlackColor.withOpacity(0.8),
                            showDragHandle: true,
                            useSafeArea: true,
                            isDismissible: true,
                            isScrollControlled: true,
                            constraints: const BoxConstraints(maxHeight: 240),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(kDefaultPadding),
                              ),
                            ),
                            enableDrag: true,
                            builder: ((builder) => uploadProductImage()),
                          );
                        },
                        splashColor: kAccentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: media.width,
                          height: deviceType(media.width) >= 2
                              ? media.width * 0.4
                              : media.height * 0.2,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 0.50,
                                color: Color(0xFFE6E6E6),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/image-upload.png",
                                    ),
                                    kHalfSizedBox,
                                    const Text(
                                      'Upload product images',
                                      style: TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              : selectedImage == null
                                  ? const SizedBox()
                                  : GridTile(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(selectedImage!),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      kSizedBox,
                      const Text(
                        'Product Type',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.32,
                        ),
                      ),
                      kHalfSizedBox,
                      SizedBox(
                        child: MyDropDownMenu(
                          controller: productTypeEC,
                          hintText: "Choose product type",
                          dropdownMenuEntries: _productType == null
                              ? [
                                  const DropdownMenuEntry(
                                      value: 'Loading...', label: 'Loading...')
                                ]
                              : _productType!
                                  .map((item) => DropdownMenuEntry(
                                      value: item.id, label: item.name))
                                  .toList(),
                        ),
                      ),
                      kSizedBox,
                      const Text(
                        'Category',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.32,
                        ),
                      ),
                      kHalfSizedBox,
                      MyDropDownMenu(
                        controller: productSubCategoryEC,
                        hintText: "Select a category for your product",
                        dropdownMenuEntries: _subCategory == null
                            ? [
                                const DropdownMenuEntry(
                                    value: 'Loading...', label: 'Loading...')
                              ]
                            : _subCategory!
                                .map((item) => DropdownMenuEntry(
                                    value: item.id, label: item.name))
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
                        hintText: "Enter the unit price here (NGN)",
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          const pricePattern = r'^\d+(\.\d{2})?$';
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
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
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
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        maxLines: 10,
                        maxLength: 1000,
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            productDescriptionFN.requestFocus();
                            return "Enter the product name";
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
      ),
    );
  }
}
