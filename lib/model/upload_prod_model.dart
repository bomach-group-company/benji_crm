import 'dart:io';

class UploadProduct {
  int? vendorId;
  String? name;
  String? description;
  String? subCategoryId;
  String? price;
  bool? isAvailable;
  String? qty;
 // String? catId;
  File? image;

  UploadProduct(
      {required this.vendorId,
      required this.name,
      required this.description,
      required this.subCategoryId,
      required this.price,
      required this.isAvailable,
      required this.image,
      required this.qty,
   //   required this.catId
      });
}




class UploadVariety {
  dynamic id;
  String? price;
  String? option;
  String? title;
 

  UploadVariety(
      {required this.id,
      required this.price,
      required this.option,
      required this.title,
    });
}
