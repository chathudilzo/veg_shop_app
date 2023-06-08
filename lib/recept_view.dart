import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:veg_shop_app/vegeitable_controller.dart';

class ReceptPage extends StatefulWidget {
   ReceptPage({super.key});

  @override
  State<ReceptPage> createState() => _ReceptPageState();
}

class _ReceptPageState extends State<ReceptPage> {
VegetableController controller=Get.find();

 List<Map<String,dynamic>> recepts=[];
 late List<Widget>_listViewItems=[];


 bool _isLoading=true;
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRecepts();
  }

void fetchRecepts()async{
final List<Map<String,dynamic>> _recepts=await controller.getRecepts();
List<Widget>listViewItems=[];
print(_recepts);
  for(final recept in _recepts){
    final int id=recept['id'] as int;
    final String date=recept['date'] as String;
    final int receptNo=recept['receptNo'] as int;
    final String jsonData=recept['jsonData'] as String;
    final double total=recept['total'] as double;

    final List<dynamic> jsonDataList=jsonDecode(jsonData);
    final List<TableRow> tableRows=[];

    for(final itemData in jsonDataList){
      final String name=itemData['name'] as String;
      final double pricePerKg=itemData['pricePerKg'] as double;
      final double grams=itemData['grams'] as double;
      final double price=itemData['price'] as double;

        final TableRow row = TableRow(
          children: [
            TableCell(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(name,style: TextStyle(fontSize: 20),)])),
            TableCell(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(pricePerKg.toStringAsFixed(2),style: TextStyle(fontSize: 20),)])),
            TableCell(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(grams.toStringAsFixed(2),style: TextStyle(fontSize: 20),)])),
            TableCell(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(price.toStringAsFixed(2),style: TextStyle(fontSize: 20),)])),
          ],
        );

    tableRows.add(row);
    }

    final Widget receptWidget=
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient: LinearGradient(colors: [Colors.cyanAccent,Colors.blueAccent])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Date:$date | Recept No:$receptNo | Total Bill Rs:$total',style: TextStyle(fontSize: 16),),
            SizedBox(height: 10,),
              Table(
                border: TableBorder.all(),
                defaultColumnWidth: FixedColumnWidth(MediaQuery.of(context).size.width/4-13),
                children: [
                TableRow(
                  children: [
                    TableCell(child: Center(child: Text('Item',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),))),
                    TableCell(child: Center(child: Text('1KG Rs',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))),
                    TableCell(child: Center(child: Text('Grams',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))),
                    TableCell(child: Center(child: Text('Price',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)))
                    
                    ]
                ),
                ...tableRows.map((row) =>TableRow(children: row.children) )
              ],
              
            )
          ],
          ),
        );
        

    listViewItems.add(receptWidget);
 
  }
  if(_recepts.isNotEmpty){
    setState(() {
      _listViewItems=listViewItems;
      _isLoading=false;
    });
  }
}
    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recepts'),),
      body:_isLoading?Container(): Padding(
        padding: const EdgeInsets.all(8.0),
        child:_isLoading?LoadingAnimationWidget.inkDrop(color: Colors.green,size: 35):ListView(
          shrinkWrap: true,
          children: _listViewItems,),
      ),
    );
  }
}
