import '../src/providers/constants.dart';
import 'business_type_model.dart';
import 'country_model.dart';
import 'my_vendor_model.dart';

class VendorBusinessModel {
  String id;
  MyVendorModel vendorOwner;
  CountryModel country;
  String state;
  String city;
  String weekOpeningHours;
  String weekClosingHours;
  String satOpeningHours;
  String satClosingHours;
  String sunWeekOpeningHours;
  String sunWeekClosingHours;
  String address;
  String shopName;
  BusinessType shopType;
  dynamic shopImage;
  dynamic coverImage;
  String longitude;
  String latitude;
  String businessId;
  String businessBio;
  String accountName;
  String accountNumber;
  String accountType;
  String accountBank;
  dynamic agent;

  VendorBusinessModel({
    required this.id,
    required this.vendorOwner,
    required this.country,
    required this.state,
    required this.city,
    required this.weekOpeningHours,
    required this.weekClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
    required this.address,
    required this.shopName,
    required this.shopType,
    required this.shopImage,
    required this.coverImage,
    required this.longitude,
    required this.latitude,
    required this.businessId,
    required this.businessBio,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.accountBank,
    required this.agent,
  });

  factory VendorBusinessModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return VendorBusinessModel(
      id: json['id'] ?? notAvailable,
      vendorOwner: MyVendorModel.fromJson(json['vendor_owner'] ?? {}),
      country: CountryModel.fromJson(json['country'] ?? {}),
      state: json['state'] ?? notAvailable,
      city: json['city'] ?? notAvailable,
      weekOpeningHours: json['weekOpeningHours'] ?? notAvailable,
      weekClosingHours: json['weekClosingHours'] ?? notAvailable,
      satOpeningHours: json['satOpeningHours'] ?? notAvailable,
      satClosingHours: json['satClosingHours'] ?? notAvailable,
      sunWeekOpeningHours: json['sunWeekOpeningHours'] ?? notAvailable,
      sunWeekClosingHours: json['sunWeekClosingHours'] ?? notAvailable,
      address: json['address'] ?? notAvailable,
      shopName: json['shop_name'] ?? notAvailable,
      shopType: BusinessType.fromJson(json['shop_type'] ?? {}),
      shopImage: json['shop_image'] ?? notAvailable,
      coverImage: json['coverImage'] ?? notAvailable,
      longitude: json['longitude'] ?? "",
      latitude: json['latitude'] ?? "",
      businessId: json['businessId'] ?? notAvailable,
      businessBio: json['businessBio'] ?? notAvailable,
      accountName: json['accountName'] ?? notAvailable,
      accountNumber: json['accountNumber'] ?? notAvailable,
      accountType: json['accountType'] ?? notAvailable,
      accountBank: json['accountBank'] ?? notAvailable,
      agent: json['agent'],
    );
  }
}
