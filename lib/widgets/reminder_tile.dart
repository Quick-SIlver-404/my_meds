import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_meds/utilities/db_helper.dart';
import 'package:my_meds/utilities/medicine_controller.dart';
import '../models/medicine.dart';
import 'date.dart';
import 'package:my_meds/widgets/themes.dart';
import 'package:get/get.dart';
class ReminderTile extends StatelessWidget {

  final _itemController = Get.put(ItemController());
  final int id;
  final String title;
  final String note;
  final String date;
  final String? time;
  final int? dose;
  final int type;
  final int? meal;
  final int? sequence;

  ReminderTile(
      {Key? key,
      required this.title,
      required this.note,
      required this.date,
      this.time,
      this.dose,
      required this.type,
      this.sequence,
      this.meal, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        _updateDose(id);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: MyTheme.titleStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  note,
                  style: MyTheme.noteStyle,
                ),
              ),
              Visibility(
                visible: type == 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DateWidget(
                        date: date,
                        isDate: true,
                      ),
                      DateWidget(
                        time: time,
                        isDate: false,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: type == 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_getTimeForMeal(meal ?? 1, sequence ?? 1),
                      style: MyTheme.noteStyle,),
                      Text('Dose left: ${dose.toString()}',
                      style: MyTheme.noteStyle,)
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeForMeal(int meal, int sequence) {
    String first, second;

    switch (meal) {
      case 0:
        second = "breakfast";
        break;
      case 1:
        second = "lunch";
        break;
      default:
        second = "dinner";
    }

    switch (sequence) {
      case 0:
        first = "After";
        break;
      default:
        first = "Before";
    }

    return '$first $second';
  }

  void _updateDose(int id) async {

    var medicine = await DBHelper.getSpecificItem(id);

    var doseEditingController = TextEditingController();

    await Get.defaultDialog(
      title: 'Change dose',
      textCancel: 'Cancel',
      textConfirm: "Confirm",
      onCancel: (){
        Get.back();
      },
      onConfirm: () async {
        var newDose = int.parse(doseEditingController.text.toString());
        medicine.dose = newDose;
        await _itemController.updateItem(medicine: medicine);
        _itemController.getAllItems(DateFormat.yMd().format(DateTime.now()));
        _itemController.getMedicines();
        Get.back();
      },
      content: TextField(
        controller: doseEditingController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: medicine.dose.toString(),
        ),
      )
    );
  }
}
