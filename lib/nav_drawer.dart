import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veg_shop_app/about_page.dart';

import 'add_items.dart';
import 'recept_view.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'SellWink',
                style: GoogleFonts.lobster(textStyle: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.green
      // Other text style properties
    ),),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/menuimg.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Update Items'),
            onTap: () => {Get.to(()=>ADDandUpdatePage())},
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('Recepts'),
            onTap: () => {Get.to(()=>ReceptPage())},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () => {Get.to(()=>About())},
          ),
          // ListTile(
          //   leading: Icon(Icons.border_color),
          //   title: Text('Feedback'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
        ],
      ),
    );
  }
}