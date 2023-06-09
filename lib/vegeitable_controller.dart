import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:veg_shop_app/buy_item_data_class.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:veg_shop_app/vegItemClass.dart';

class VegetableController extends GetxController {
  late final Database database;

  final itemList = <VegetableItem>[].obs;
  final  finalValueList=<Map<String,dynamic>>[].obs;
  var dayTotal=0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
  }

  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();

    final pathToDatabase = join(databasePath, 'vegetables.db');

    database =
        await openDatabase(pathToDatabase, version: 1, onCreate: (db, version) {
      db.execute('''CREATE TABLE IF NOT EXISTS recepts(
        id INTEGER PRIMARY KEY,
        date TEXT,
        receptNo INTEGER,
        jsonData TEXT,
        total REAL
      )''');
      db.execute('''CREATE TABLE IF NOT EXISTS vegetables(
        id INTEGER PRIMARY KEY,
        name TEXT,
        pricePerKg REAL
      )''');

      db.execute('''CREATE TABLE IF NOT EXISTS dailytotal(
        id INTEGER PRIMARY KEY,
        date TEXT,
        total REAL
      )''');
      
    });

    //addDummyData();
    getDaysTotals();
    loadItems();
    dayTotal.value=await getGivenDayTotal(DateTime.now().toString());
  }

  Future<void> loadItems() async {
    final items = await database.query('vegetables');
    itemList.value = items
        .map((item) => VegetableItem(
              name: item['name'].toString(),
              pricePerKg: item['pricePerKg'] as double,
            ))
        .toList();

        print(itemList);
  }

  Future<List<Map<String,dynamic>>> getRecepts() async {
    try {
      final List<Map<String,dynamic>>recepts = await database.query('recepts');
      return recepts;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getDaysTotals()async{
    try{
      final List<Map<String,dynamic>>days=await database.query('dailytotal');
      print(days);
      return days;
    }catch(e){
      return [];
    }
  }

Future<double>getGivenDayTotal(String day)async{
  try{
    double total=0.00;
DateTime parsedDay = DateTime.parse(day);
    String formattedDay = DateFormat('yyyy-MM-dd').format(parsedDay);

    day=(formattedDay);
    final List<Map<String,dynamic>> result=await database.query('dailytotal',where:'date=?',whereArgs:[day]);
    if(result.isNotEmpty){
      total=result.first['total'] as double;
    }
    print(total);
    return total;
  }catch(e){
    print(e.toString());
    return 0.0;
  }
}

Future<void>getTotalvalues()async{
  try{
    final List<Map<String,dynamic>> recepts=await getRecepts();
final List<Map<String,dynamic>> valueList=[];

    for(final recept in recepts){
      final String jsonData=recept['jsonData'] as String;
      final List<dynamic> jsonDataList=jsonDecode(jsonData);

      for(final itemData in jsonDataList){
        var found=false;
        for(Map<String,dynamic> item in valueList){
          String name=item['name'];
          double grams=item['grams'];

          if(name==itemData['name'] as String){
           item['grams']=grams+itemData['grams'];
            found=true;
            break;
          }
        }
        if(!found){
          valueList.add({'name':itemData['name'],'grams':itemData['grams']});

        }
      }
    }
    finalValueList.value=valueList;
    print('ValueList:$finalValueList');
  }catch(e){
print(e.toString());
  }
}

  Future<void>updateDailyTotal(String date,double bill)async{
    try{
      final List<Map<String,dynamic>>result=await database.query('dailytotal',where:'date=?',whereArgs: [date]);

      if(result.isNotEmpty){
        final double currentTotal=result.first['total'] as double;
        final double newTotal=currentTotal+bill;

        await database.update('dailytotal', {
          'total':newTotal
        },where: 'date=?',whereArgs: [date]);
        
      }else{
        await database.insert('dailytotal',{'date':date,'total':bill});
      }

    }catch(e){
print(e.toString());
    }
  }

  Future<void> addItem(String name, double pricePerKg) async {
    try{
      final item = VegetableItem(name: name, pricePerKg: pricePerKg);

    await database
        .insert('vegetables', {'name': name, 'pricePerKg': pricePerKg});
    await loadItems();
    Get.snackbar('Success', 'Item Added Successfully');
    }catch(e){
      Get.snackbar('Error', e.toString());
    }
  }

  void addDummyData() {
    final dummyData = [
      {'name': 'Carrot', 'pricePerKg': 10.0},
      {'name': 'Banana', 'pricePerKg': 20.0},
      {'name': 'Cucumber', 'pricePerKg': 15.0},
      {'name': 'Tomato', 'pricePerKg': 25.0},
      {'name': 'Potato', 'pricePerKg': 12.0},
      {'name': 'Onion', 'pricePerKg': 8.0},
      {'name': 'Broccoli', 'pricePerKg': 18.0},
      {'name': 'Spinach', 'pricePerKg': 14.0},
      {'name': 'Capsicum', 'pricePerKg': 22.0},
      {'name': 'Lettuce', 'pricePerKg': 16.0},
      {'name': 'Vegetable 1', 'pricePerKg': 11.0},
      {'name': 'Vegetable 2', 'pricePerKg': 13.0},
      {'name': 'Vegetable 3', 'pricePerKg': 17.0},
      {'name': 'Vegetable 4', 'pricePerKg': 19.0},
      {'name': 'Vegetable 5', 'pricePerKg': 21.0},
      {'name': 'Vegetable 6', 'pricePerKg': 9.0},
      {'name': 'Vegetable 7', 'pricePerKg': 23.0},
      {'name': 'Vegetable 8', 'pricePerKg': 7.0},
      {'name': 'Vegetable 9', 'pricePerKg': 24.0},
      {'name': 'Vegetable 10', 'pricePerKg': 26.0},
    ];

    for (final data in dummyData) {
      addItem(data['name'].toString(), data['pricePerKg'] as double);
    }
  }

  Future<void> updateItem(int index, double pricePerKg) async {
    final item = itemList[index];
    await database.update(
        'vegetables',
        {
          'pricePerKg': pricePerKg,
        },
        where: 'name=?',
        whereArgs: [item.name]);
    await loadItems();
  }

  Future<void> deleteItem(String name)async{
    try{
      await database.rawDelete('DELETE FROM vegetables WHERE name=?',[name]);
      await loadItems();
    }catch(e){
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> saveRecept(
      Map<String, BuyItemData> recepts, double total) async {
    try {
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
await updateDailyTotal(currentDate, total);
      final result = await database.query('recepts');
      print('recepts table$result');
dayTotal.value=await getGivenDayTotal(DateTime.now().toString());
print('daytotal:${dayTotal}');
      final lastRectNo =
          result.isNotEmpty ? result.last['receptNo'] as int? : 0;

      final receptNo = (lastRectNo ?? 0) + 1;

      await database.transaction((txn) async {
        String jsonData = '';

        List<Map<String, dynamic>> jsonList = [];
for (final entry in recepts.entries) {
  final item = entry.value;
  final itemJson = item.toJson();
  jsonList.add(itemJson);
}
 jsonData = jsonEncode(jsonList);


        await txn.rawInsert(
            'INSERT INTO recepts(date,receptNo,jsonData,total)'
            'VALUES(?,?,?,?)',
            [currentDate, receptNo, jsonData, total]);
      });

      await getTotalvalues();
    } catch (e) {
      print(e);
    }
  }
}
