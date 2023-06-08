import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:veg_shop_app/home_page.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
     double height=MediaQuery.of(context).size.height;
    return AnimatedSplashScreen(
      duration: 5000,
      splashTransition: SplashTransition.fadeTransition,
      
      splash:Container(
        width: width,
        height: height,
        
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/loadingscreen.gif'),fit: BoxFit.cover)),
        child: Container()
           
      ),
      
      nextScreen:AnimatedSplashScreen(
        duration: 3000,
      splash: Column(
        children: [
          Text('SellWink',style:GoogleFonts.lobster(textStyle: TextStyle(fontSize: 50,color: Color.fromARGB(255, 129, 175, 76),fontWeight: FontWeight.bold)))
        ],
      ),
      nextScreen: HomePage(),
      splashTransition: SplashTransition.rotationTransition,
      
    ) ,
      );
    
  }
}