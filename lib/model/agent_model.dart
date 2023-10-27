import 'package:benji_aggregator/src/providers/constants.dart';

class AgentModel {
  String firstName;
  String lastName;
  String address;
  String gender;
  String religion;
  String worshipHours;
  String stateOfOrigin;
  String lga;
  String permanentAddress;
  String residentialAddress;
  String nearestBusStop;
  String maritalStatus;
  String nameOfSpouse;
  String phoneNumberOfSpouse;
  String license;

  AgentModel({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.gender,
    required this.religion,
    required this.worshipHours,
    required this.stateOfOrigin,
    required this.lga,
    required this.permanentAddress,
    required this.residentialAddress,
    required this.nearestBusStop,
    required this.maritalStatus,
    required this.nameOfSpouse,
    required this.phoneNumberOfSpouse,
    required this.license,
  });
  factory AgentModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return AgentModel(
      firstName: json['first_name'] ?? notAvailable,
      lastName: json['last_name'] ?? notAvailable,
      address: json['address'] ?? notAvailable,
      gender: json['gender'] ?? notAvailable,
      religion: json['religion'] ?? notAvailable,
      worshipHours: json['worship_hours'] ?? notAvailable,
      stateOfOrigin: json['stateOfOrigin'] ?? notAvailable,
      lga: json['lga'] ?? notAvailable,
      permanentAddress: json['permanent_address'] ?? notAvailable,
      residentialAddress: json['residential_address'] ?? notAvailable,
      nearestBusStop: json['nearest_bus_stop'] ?? notAvailable,
      maritalStatus: json['marital_status'] ?? notAvailable,
      nameOfSpouse: json['nameOfSpouse'] ?? notAvailable,
      phoneNumberOfSpouse: json['phoneNumberOfSpouse'] ?? notAvailable,
      license: json['license'] ?? notAvailable,
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address": address,
        "gender": gender,
        "religion": religion,
        "worship_hours": worshipHours,
        "stateOfOrigin": stateOfOrigin,
        "lga": lga,
        "permanent_address": permanentAddress,
        "residential_address": residentialAddress,
        "nearest_bus_stop": nearestBusStop,
        "marital_status": maritalStatus,
        "nameOfSpouse": nameOfSpouse,
        "phoneNumberOfSpouse": phoneNumberOfSpouse,
        "license": license,
      };
}
