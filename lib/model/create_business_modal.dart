import 'dart:io';

class SendCreateModel {
  File? profileImage;
  String? vendorEmail;
  String? vendorPhone;
  String? bussinessAddress;
  String? country;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? firstName;
  String? lastName;
  SendCreateModel({
    this.profileImage,
    this.vendorEmail,
    this.vendorPhone,
    this.bussinessAddress,
    this.country,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.firstName,
    this.lastName,
  });
}
