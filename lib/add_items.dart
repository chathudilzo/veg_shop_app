import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:veg_shop_app/vegItemClass.dart';
import 'package:veg_shop_app/vegeitable_controller.dart';

class ADDandUpdatePage extends StatelessWidget {
   ADDandUpdatePage({super.key});

final VegetableController controller=Get.find();

var _priceControllers=<String ,TextEditingController>{};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Database'),
        actions: [
          IconButton(onPressed:(){
            TextEditingController _nameController=TextEditingController();
            TextEditingController _priceController=TextEditingController();
            final _formKey1=GlobalKey<FormState>();

            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text('Add Item'),
                content: Form(child: Column(
                  children: [
                    TextFormField(controller: _nameController,
                    decoration: InputDecoration(label: Text('Item Name'),hintText:'carrot'),
                    validator: (value) {
                      if(value==null||value.isEmpty){
                        return 'Item Name cannot be empty';
                      }
                    },
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value==null||value.isEmpty){
                          return 'Price cannot be empty';
                        }
                      },               decoration: InputDecoration(label: Text('Price'),prefix: Text('Rs:')),
                    )
                  ],
                )
                ),
                actions: [
                  ElevatedButton(onPressed: ()async{
                    if(_formKey1.currentState!.validate()){
await controller.addItem(_nameController.text,double.parse(_priceController.text));
                    }
                  }, child: Center(child:
                  Text('Add')))
                ],
              );
            });
          } , icon: Icon(Icons.add))
        ],
      ),
      body: Container(
child:controller.itemList.isNotEmpty? Obx(()=>Center(
  child:   SizedBox(
  
  width: width*0.8,
  
  height: height*0.8,
  
  child: ListView.builder(
  
    itemCount: controller.itemList.length,
  
    itemBuilder: (context,index){
  
    final item=controller.itemList[index];
  
    return Container(
  
    height: height*0.05,
  
    margin: const EdgeInsets.only(bottom: 10),
  
    decoration: BoxDecoration(color: Color.fromARGB(255, 186, 187, 186),borderRadius: BorderRadius.circular(10)),
  
    child: Center(
  
      child: Row(
  
        mainAxisAlignment: MainAxisAlignment.spaceAround,
  
        children: [
  
          Text(item.name),
  
          Text(item.pricePerKg.toStringAsFixed(2)),

          TextButton(onPressed: (){
            TextEditingController priceController=TextEditingController();
            priceController.text=item.pricePerKg.toStringAsFixed(2);
            final _formKey=GlobalKey<FormState>();

            showDialog(context:context,builder:(BuildContext context){
              return AlertDialog(
                content: Container(
                  height: height*0.1,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.name),
                        TextFormField(
                          
                          decoration: InputDecoration(prefix: Text('Rs:'),label: Text('1 KG')),
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          
                          validator: (value) {
                            if(value==null||value.isEmpty){
                              return 'Price Cannot be empty';
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      controller.updateItem(index, double.parse(priceController.text));
                      Navigator.of(context).pop();

                    }
                  }, child: Text('Update')),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('cancel'))
                ],
              );
            });
          }, child: Text('Update')),
          TextButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text('Confirm Delete'),
                content: Text('Are you sure you want to delete ${item.name}?'),
                actions: [
                  TextButton(onPressed: ()async
                  {
                    controller.deleteItem(item
                    .name);
                    Navigator.of(context).pop();
                  }, child: Text('Yes')),TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('No'))
                ],
              );
            });
          }, child: Text('Delete',style: TextStyle(color: Colors.red),))
            
        ],
  
      ),
  
    ),
  
  );
  
  }),
  
  ),
)):Center(child: LoadingAnimationWidget.hexagonDots(color: Colors.blue
, size: 35),)
      ),
    );
  }
}