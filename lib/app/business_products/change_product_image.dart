import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/src/components/appbar/my_appbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/api_processor_controller.dart';
import '../../controller/form_controller.dart';
import '../../controller/product_controller.dart';
import '../../model/product_model.dart';
import '../../services/api_url.dart';

import '../../src/components/button/my_elevatedButton.dart';
import '../../src/components/image/my_image.dart';
import '../../src/utils/constants.dart';
import '../../theme/colors.dart';

class ChangeProductImage extends StatefulWidget {
  final ProductModel product;

  const ChangeProductImage({super.key, required this.product});

  @override
  State<ChangeProductImage> createState() => _ChangeProductImageState();
}

class _ChangeProductImageState extends State<ChangeProductImage> {
  @override
  void initState() {
    super.initState();

    productImage = widget.product.productImage;
  }

  final formKey = GlobalKey<FormState>();

//=========================== IMAGE PICKER ====================================\\

  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String? productImage;

//=========================== FUNCTION ====================================\\

  Future<void> submit() async {
    if (productImage!.isEmpty || selectedImage == null) {
      ApiProcessorController.errorSnack("Please select an image");
    }
    Map<String, dynamic> data = {
      'product_image': selectedImage,
    };

    log("This is the data : $data");

    await FormController.instance.uploadImage(
      Api.baseUrl + Api.changeProductImage + widget.product.id,
      {'product_image': selectedImage},
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

  pickProductImages(ImageSource source) async {
    final XFile? image = await picker.pickImage(
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
      height: 160,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Upload Product Image",
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
                    onTap: () async {
                      Navigator.pop(context);
                      await pickProductImages(ImageSource.camera);
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
                    onTap: () async {
                      Navigator.pop(context);

                      await pickProductImages(ImageSource.gallery);
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
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: "Change the product image",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: kPrimaryColor),
        child: GetBuilder<FormController>(
          init: FormController(),
          builder: (saving) {
            return MyElevatedButton(
              onPressed: () async {
                submit();
              },
              isLoading: saving.isLoad.value,
              title: "Save",
            );
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          children: [
            selectedImage == null
                ? Container(
                    width: media.width,
                    height: media.height * 0.3,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 0.50,
                          color: Color(0xFFE6E6E6),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: MyImage(url: productImage!),
                    ),
                  )
                : GridTile(
                    child: DottedBorder(
                      color: kLightGreyColor,
                      borderPadding: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20),
                      child: Container(
                        width: media.width,
                        height: media.height * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(selectedImage!),
                          ),
                        ),
                      ),
                    ),
                  ),
            kHalfSizedBox,
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
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Upload product image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAccentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
