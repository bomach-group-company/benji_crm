import 'dart:io';

class SendCreateModel {
  File? profileImage;
  String? email;
  String? phoneNumber;
  String? personalID;
  String? address;
  String? country;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? firstName;
  String? lastName;
  String? lga;
  SendCreateModel({
    this.profileImage,
    this.email,
    this.phoneNumber,
    this.personalID,
    this.address,
    this.country,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.firstName,
    this.lastName,
    this.lga,
  });
}
