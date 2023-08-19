import 'dart:convert';

class SendLogin {
  String username;
  String password;

  SendLogin({required this.password, required this.username});
}


// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);



LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String? token;

    LoginModel({
        this.token,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
