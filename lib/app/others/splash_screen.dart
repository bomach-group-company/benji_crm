import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controller.dart';

class SplashScreen extends StatelessWidget {

 var val =  Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  GetBuilder<LoginController>(
              init: LoginController(isFirst: true),
              builder: (controller) {
               
        return Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
    
    
             Image.asset("assets/images/logo/benji_blue_logo_icon.jpg", height: 50,width: 50,)
    
            ],
          ),
        );
      }
    );
  }
}
