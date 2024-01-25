// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/api_processor_controller.dart';
import '../../controller/business_controller.dart';
import '../../controller/form_controller.dart';
import '../../controller/product_controller.dart';
import '../../controller/user_controller.dart';
import '../../model/business_model.dart';
import '../../model/product_model.dart';
import '../../model/product_type_model.dart';
import '../../model/sub_category.dart';
import '../../services/api_url.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/input/message_textformfield.dart';
import '../../src/components/input/my_dropdown_menu.dart';
import '../../src/components/input/my_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../src/responsive/responsive_constant.dart';
import '../../theme/colors.dart';

class AddProduct extends StatefulWidget {
  final BusinessModel business;
  const AddProduct({super.key, required this.business});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  void initState() {
    super.initState();
    isToggled = true;

    getSubCategories().then((value) {
      subCategoryEC = value;
      setState(() {});
    });
    getProductType().then((value) {
      productType = value;
      setState(() {});
    });
  }

  //============================= ALL VARIABLES =====================================\\
  var agentId = UserController.instance.user.value.id;

  //===================== GLOBAL KEYS =======================\\
  final formKey = GlobalKey<FormState>();

  //================================== FOCUS NODES ====================================\\
  final productTypeFN = FocusNode();
  final productNameFN = FocusNode();
  final productDescriptionFN = FocusNode();
  final productPriceFN = FocusNode();
  final productQuantityFN = FocusNode();
  final productDiscountFN = FocusNode();
  final vendorBusinessFN = FocusNode();

  //================================== CONTROLLERS ====================================\\
  final scrollController = ScrollController();
  final productNameEC = TextEditingController();
  final productDescriptionEC = TextEditingController();
  final productPriceEC = TextEditingController();
  final productQuantityEC = TextEditingController();
  final productSubCategoryEC = TextEditingController();
  final productTypeEC = TextEditingController();
  final vendorBusinessEC = TextEditingController();

  //================================== VALUES ====================================\\

  List<SubCategory>? subCategoryEC;
  List<ProductTypeModel>? productType;
  var product = ProductModel;

  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  // bool categorySelected = false;
  var isToggled;

  int? selectedCategory;

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImages;

  //================================== FUNCTIONS ====================================\\
  Future<void> submit() async {
    if (selectedImages == null) {
      ApiProcessorController.errorSnack("Please select product images");
      return;
    }
    if (productType == null || productTypeEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select a product type");
      return;
    }
    if (subCategoryEC == null || productSubCategoryEC.text.isEmpty) {
      ApiProcessorController.errorSnack("Please select a category");
      return;
    }
    Map data = {
      'name': productNameEC.text,
      'description': productDescriptionEC.text,
      'price': productPriceEC.text,
      'quantity_available': productQuantityEC.text,
      'sub_category_id': productSubCategoryEC.text,
      'product_type': productTypeEC.text,
      'vendor_id': widget.business.id,
      'business_id': vendorBusinessEC.text,
      'is_available': true,
      'is_recommended': true,
      'is_trending': true,
    };
    await FormController.instance.postAuthstream(
      Api.baseUrl + Api.addProduct,
      data,
      {'product_image': selectedImages},
      'addProduct',
    );
    if (FormController.instance.status.toString().startsWith('2')) {
      await ProductController.instance.reset();
      // await PushNotificationController.showNotification(
      //   title: "Success",
      //   body: "${productNameEC.text} has been added to your products",
      // );
      Get.close(1);
      // Get.offAll(
      //   () => const OverView(currentIndex: 2),
      //   routeName: 'OverView',
      //   duration: const Duration(milliseconds: 300),
      //   fullscreenDialog: true,
      //   curve: Curves.easeIn,
      //   popGesture: true,
      //   transition: Transition.rightToLeft,
      // );
    }
  }

  pickProductImages(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedImages = File(image.path);
      setState(() {});
    }
  }

  //=========================== WIDGETS ====================================\\
  Widget uploadProductImages(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: deviceType(media.width) >= 2 ? 200 : 160,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Upload Product Images",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          kSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickProductImages(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side:
                              const BorderSide(width: 0.5, color: kGreyColor1),
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.camera,
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
                      pickProductImages(ImageSource.gallery);
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
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add New Product",
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
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 144,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFE6E6E6),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: selectedImages == null
                              ? Image.asset(
                                  "assets/icons/image-upload.png",
                                )
                              : selectedImages == null
                                  ? const SizedBox()
                                  : GridTile(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(selectedImages!),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      kSizedBox,
                      Center(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              elevation: 20,
                              barrierColor: kBlackColor.withOpacity(0.8),
                              showDragHandle: true,
                              useSafeArea: true,
                              isDismissible: true,
                              isScrollControlled: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(kDefaultPadding),
                                ),
                              ),
                              builder: ((builder) =>
                                  uploadProductImages(context)),
                            );
                          },
                          splashColor: kAccentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Upload product images',
                              style: TextStyle(
                                color: kAccentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      kSizedBox,
                      const Text(
                        'Businesses',
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.32,
                        ),
                      ),
                      kHalfSizedBox,
                      GetBuilder<BusinessController>(
                        initState: (state) {
                          BusinessController.instance.getBusinesses(
                              widget.business.vendorOwner.id.toString(),
                              agentId);
                        },
                        builder: (controller) {
                          return MyDropDownMenu(
                            controller: vendorBusinessEC,
                            hintText: "E.g Restaurant, Auto Dealer, etc",
                            dropdownMenuEntries:
                                controller.listOfBusinesses.isEmpty &&
                                        controller.isLoad.value
                                    ? [
                                        const DropdownMenuEntry(
                                          value: 'Loading...',
                                          label: 'Loading...',
                                          enabled: false,
                                        )
                                      ]
                                    : controller.listOfBusinesses
                                        .map((item) => DropdownMenuEntry(
                                            value: item.id,
                                            label: item.shopName))
                                        .toList(),
                          );
                        },
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
                      MyDropDownMenu(
                        controller: productTypeEC,
                        hintText: "Choose product type",
                        dropdownMenuEntries: productType == null
                            ? [
                                const DropdownMenuEntry(
                                  value: 'Loading...',
                                  label: 'Loading...',
                                  enabled: false,
                                )
                              ]
                            : productType!
                                .map((item) => DropdownMenuEntry(
                                    value: item.id, label: item.name))
                                .toList(),
                      ),
                      kSizedBox,
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
                        controller: productSubCategoryEC,
                        hintText: "Select a category for your product",
                        dropdownMenuEntries: subCategoryEC == null
                            ? [
                                const DropdownMenuEntry(
                                  value: 'Loading...',
                                  label: 'Loading...',
                                  enabled: false,
                                )
                              ]
                            : subCategoryEC!
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
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.done,
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
