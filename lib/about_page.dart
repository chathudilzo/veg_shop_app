import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('About'),),
      body: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color.fromARGB(255, 57, 62, 73),Color.fromARGB(255, 48, 46, 46)]),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(image: AssetImage('assets/profile.jpg'),fit: BoxFit.cover)
                ),
              ),
              Text("Hi i'm Chathura Dilshan &",style:TextStyle(fontSize: 25,color: Colors.white)),
              RichText(text:TextSpan(text: 'Welcome to ',style: const TextStyle(
                color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold
              ),children: <TextSpan>[TextSpan(text: 'SellWink!🌟',style: GoogleFonts.lobster(textStyle: const TextStyle(color: Colors.green)))]) ),
         Text("SellWink is a comprehensive shop sales management app designed to streamline and simplify your sales operations. Developed by Chathura Dilshan, this app is your ultimate companion in boosting your shops sales and enhancing customer satisfaction.With SellWink, you can effortlessly track and manage your sales transactions, inventory, and customer interactions all in one place. Say goodbye to manual record-keeping and hello to efficient and organized sales management.Key Features of SellWink:Sales Tracking: Keep a close eye on your sales performance with detailed reports and analytics. Track sales by day, week, month, or custom date ranges, allowing you to make data-driven decisions to optimize your shop's profitability.Inventory Management: Take control of your inventory with ease. SellWink lets you manage your product catalog, track stock levels, and receive alerts when items are running low. Never miss a sales opportunity due to stockouts again!Customer Relationship Management: Build strong and lasting relationships with your customers. SellWink enables you to store customer information, track purchase history, and even send personalized promotions and offers to keep them engaged.Sales Insights: Unlock valuable insights into your sales trends and patterns. With SellWink's intuitive analytics, you can identify your best-selling products, peak sales periods, and customer preferences, empowering you to make informed business decisions.User-Friendly Interface: SellWink boasts a user-friendly and intuitive interface, making it easy for you and your staff to navigate and utilize all its powerful features. Spend less time on administrative tasks and more time focusing on growing your business.Whether you run a small boutique, a bustling retail store, or an online shop, SellWink is the ultimate tool to streamline your sales processes, increase efficiency, and maximize your profits. Join countless satisfied shop owners who have already transformed their sales management experience with SellWink.Download SellWink today and embark on a journey to sales success. Let SellWink be your trusted partner in taking your shop to new heights.Remember, SellWink is here to help you Sell with a Wink! 😉",style:GoogleFonts.breeSerif(textStyle: TextStyle(color: Colors.white))) ,
            ],
          ),
        ),
      ),
    );
  }
}