import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:veg_shop_app/add_items.dart';
import 'package:veg_shop_app/buy_item_data_class.dart';
import 'package:veg_shop_app/recept_view.dart';
import 'package:veg_shop_app/vegeitable_controller.dart';

import 'nav_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VegetableController controller = Get.find();

  var total = 0.00;
  var enteredValues = <String, BuyItemData>{};
 

  double calculateTotal(Map<String, BuyItemData> enteredValues) {
    double total = 0.00;
    enteredValues.values.forEach((element) {
      total += (element.pricePerKg / 1000) * element.grams;
      total = double.parse(total.toStringAsFixed(2));
    });
    return total;
  }



  void onPressed() {
    enteredValues.clear();
    for (final item in controller.itemList) {
      final gramController = _gramControllers[item.name];
      final textValue = gramController?.text;
      if (textValue != null && textValue.isNotEmpty) {
        try {
          final grams = double.parse(textValue);
          final itemData = BuyItemData(
            name: item.name,
            pricePerKg: item.pricePerKg,
            grams: grams,
            price: (item.pricePerKg / 1000) * grams,
          );
          enteredValues[item.name] = itemData;
        } catch (e) {
          // Handle the error here, such as showing an error message or taking another action
          print('Invalid value entered for ${item.name}');
        }
      }
    }
    setState(() {
      total = calculateTotal(enteredValues);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(enteredValues);
        return AlertDialog(
          title: Text('Total Bill'),
          content:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(),
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              'Item',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              '1KG Rs',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              'Purchase (g)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...enteredValues.entries.map((entry) {
                      final itemData = entry.value;
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(itemData.name),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(itemData.pricePerKg.toString()),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(itemData.grams.toString()),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(itemData.price.toStringAsFixed(2)),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Rs: $total',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await controller.saveRecept(enteredValues, total);
                _gramControllers.clear();
                print(controller.finalValueList.length);
                Navigator.of(context).pop();
              },
              child: Text('SAVE'),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      },
    );
  }

  // Map to store the gram controllers for each item
  var _gramControllers = <String, TextEditingController>{};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(),
        actions: [
          Center(child: Text('Total Sales Rs:${controller.dayTotal.toStringAsFixed(2)}',style: TextStyle(fontSize: 20),)),
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.calculate_outlined,size: 40,color: Color.fromARGB(255, 255, 239, 14),),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child:controller.itemList.isNotEmpty? Obx(
          () => SizedBox(
            width: width,
            height: height,
            child: ListView.builder(
              itemCount: controller.itemList.length,
              itemBuilder: (context, index) {
                final item = controller.itemList[index];
                final gramController =
                    _gramControllers[item.name] ?? TextEditingController();
                //gramController.text = 0.toString();
                _gramControllers[item.name] = gramController;

                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          'Price Per Kg: Rs ${item.pricePerKg.toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: gramController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ):Container(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LoadingAnimationWidget.fourRotatingDots(color: Colors.green
              , size: 35),
            ),
            Text('No Items to show!')
          ],
        ),)
      ),
    );
  }
}
