import 'package:get/get.dart';
import 'package:my_meds/utilities/notification_services.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';
import '../models/medicine.dart';
import 'medicine_controller.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'items';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}items.db';
      _db =
          await openDatabase(path, version: _version, onCreate: (db, version) {
        print('Creating a new database');

        var sqlCreate = "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "meal INTEGER, sequence INTEGER, dose INTEGER,"
            "time STRING, type INTEGER)";

        return db.execute(sqlCreate);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int?> insertMedicine(Medicine? medicine) async {
    var _notificationController = Get.put(NotificationController());

    print("Insert function called");
    print(medicine!.toJson().toString());
    int? id = await _db?.insert(_tableName, medicine.toJson()) ?? -1;

    print('Stored in row id: $id');
    _notificationController.sendNotification(
      medicine: medicine,
        dateTime: medicine.getDateTime(), id: id);
    return id;
  }

  static Future<int?> insertActivity(Activity? activity) async {

    var _notificationController = Get.put(NotificationController());

    print("Insert function called");
    print(activity!.toJson().toString());
    int? id = await _db?.insert(_tableName, activity.toJson()) ?? -1;
    print('Stored in row id: $id');

    _notificationController.sendNotification(
      activity: activity,
        dateTime: activity.getDateTime(), id: id);
    return id;
  }

  static Future<List<Map<String, dynamic>>> readAllMedicines() async {
    final result =
        await _db?.query(_tableName, where: '"type" = ?', whereArgs: ['1']);
    return result as List<Map<String, dynamic>>;
  }

  static Future<List<Map<String, dynamic>>> readAllActivities() async {
    final result =
        await _db?.query(_tableName, where: '"type" = ?', whereArgs: ['2']);
    return result as List<Map<String, dynamic>>;
  }

  static Future<List<Map<String, dynamic>>> readAllItems(
      {required String date}) async {
    final result =
        await _db?.query(_tableName, where: '"date" = ?', whereArgs: [date]);
    return result as List<Map<String, dynamic>>;
  }

  static updateItem(Medicine? medicine, Activity? activity) async {
    var changes;
    if (medicine != null) {
      changes = await _db?.update(_tableName, medicine.toJson(),
          where: '"id" = ?', whereArgs: [medicine.id]);
    } else {
      changes = await _db?.update(_tableName, activity!.toJson(),
          where: '"id" = ?', whereArgs: [activity.id]);
    }
    return changes;
  }

  static Future<Medicine> getSpecificItem(int id) async {
    var result =
        await _db?.query(_tableName, where: '"id" = ?', whereArgs: [id])
            as List<Map<String, dynamic>>;
    var resultItem = result[0];
    return Medicine.fromJson(resultItem);
  }

  static void reduceDose(int id) async {
    var  _itemController = Get.put(ItemController());

    var result =
        await _db?.query(_tableName, where: '"id" = ?', whereArgs: [id])
    as List<Map<String, dynamic>>;
    var resultItem = result[0];
    if(resultItem['type'] == 1){
      var medicine = Medicine.fromJson(resultItem);
      medicine.dose--;
      updateItem(medicine, null);
      _itemController.getMedicines();

      Get.snackbar('Dose reduced by 1', 'Your dose has been reduced');
    }

  }

  static Future<String> getMedicineNames() async {
    final result =
        await _db?.query(_tableName, where: '"type" = ?', whereArgs: ['1']) as List<Map<String, dynamic>>;

      if(result.isNotEmpty){
      String names = result[0]['title'];

      for (int i = 1; i < result.length; i++) {
        names = '$names \n${result[i]['title']}';
      }

      return names;
    } else {
      return '';
    }
  }
}
