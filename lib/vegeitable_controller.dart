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
    });

    addDummyData();
  }

  Future<void> loadItems() async {
    final items = await database.query('vegetables');
    itemList.value = items
        .map((item) => VegetableItem(
              name: item['name'].toString(),
              pricePerKg: item['pricePerKg'] as double,
            ))
        .toList();
  }

  Future<void> getRecepts() async {
    try {
      final recepts = await database.query('recepts');
    } catch (e) {}
  }

  Future<void> addItem(String name, double pricePerKg) async {
    final item = VegetableItem(name: name, pricePerKg: pricePerKg);

    await database
        .insert('vegetables', {'name': name, 'pricePerKg': pricePerKg});
    itemList.add(item);
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
    //item.pricePerKg = pricePerKg;
  }

  Future<void> saveRecept(
      Map<String, BuyItemData> recepts, double total) async {
    try {
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final result = await database.query('recepts');
      print('recepts table$result');

      final lastRectNo =
          result.isNotEmpty ? result.last['receptNo'] as int? : 0;

      final receptNo = (lastRectNo ?? 0) + 1;

      await database.transaction((txn) async {
        String jsonData = '';
        for (final entry in recepts.entries) {
          final item = entry.value;
          final itemJson = jsonEncode(item.toJson());
          jsonData += itemJson + ',';
        }
        jsonData = jsonData.isNotEmpty
            ? jsonData.substring(0, jsonData.length - 1)
            : '';
        await txn.rawInsert(
            'INSERT INTO recepts(date,receptNo,jsonData,total)'
            'VALUES(?,?,?,?)',
            [currentDate, receptNo, jsonData, total]);
      });
    } catch (e) {
      print(e);
    }
  }
}
