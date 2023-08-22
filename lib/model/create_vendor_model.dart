import 'dart:io';

class SendCreateModel {
  File? coverImage;
  File? profileImage;
  String? personaId;
  String? businessId;
  String? businessName;
  String? businessType;
  String? businessEmail;
  String? businessPhone;
  String? bussinessAddress;
  String? country;
  String? state;
  String? city;
  String? openHours;
  String? closeHours;
  String? satOpenHours;
  String? satCloseHours;
  String? sunOpenHours;
  String? sunCloseHours;
  String? businessBio;
  SendCreateModel(
      {this.coverImage,
      this.profileImage,
      this.personaId,
      this.businessId,
      this.businessName,
      this.businessType,
      this.businessEmail,
      this.businessPhone,
      this.bussinessAddress,
      this.country,
      this.state,
      this.city,
      this.openHours,
      this.closeHours,
      this.satOpenHours,
      this.satCloseHours,
      this.sunOpenHours,
      this.sunCloseHours});
}
