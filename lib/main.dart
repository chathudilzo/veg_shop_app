import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veg_shop_app/home_page.dart';
import 'package:veg_shop_app/splash_screen.dart';
import 'package:veg_shop_app/vegeitable_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final VegetableController vegetableController =
      Get.put(VegetableController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
