// Local Import
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_meds/widgets/reminder_tile.dart';
import 'package:my_meds/widgets/themes.dart';

// Library Import
import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/medicine.dart';
import '../utilities/db_helper.dart';
import '../utilities/medicine_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final _itemController = Get.put(ItemController());

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _itemController.getAllItems(DateFormat.yMd().format(_selectedDate));
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'.tr),
      ),
      body: Column(
        children: [
          _addDateBar(),
          _showItems(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: const Color(0x3f01a87d),
        selectedTextColor: MyTheme.textColor,
        dateTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
            _itemController.getAllItems(DateFormat.yMd().format(_selectedDate));
            print(_selectedDate);
          });
        },
      ),
    );
  }

//   _showTasks() {
//     if (_itemController.itemsList.isEmpty) {
//       return const Expanded(
//         child: Center(
//           child: Text("No item stored yet"),
//         ),
//       );
//     } else {
//       return Expanded(
//           child: Obx((){
//
//           ListView.builder(
//               itemCount: _itemController.itemsList.length,
//               itemBuilder: (
//               BuildContext context, int index) {
//         if (_itemController.itemsList[index]['date'] ==
//             DateFormat.yMd().format(_selectedDate)) {
//           return Obx(() {
//             if (_itemController.itemsList[index]['type'] == 1) {
//               //Medicine
//               var medicine =
//                   Medicine.fromJson(_itemController.itemsList[index]);
//               return ReminderTile(
//                 title: medicine.title as String,
//                 note: medicine.note as String,
//                 date: medicine.date as String,
//                 type: medicine.type as int,
//                 meal: medicine.meal,
//                 sequence: medicine.sequence,
//                 dose: medicine.dose,
//               );
//             } else {
//               //Activities
//               var activity =
//                   Activity.fromJson(_itemController.itemsList[index]);
//
//               return ReminderTile(
//                 title: activity.title as String,
//                 note: activity as String,
//                 date: activity as String,
//                 type: activity.type as int,
//                 time: activity.time,
//               );
//             }
//           });
//         } else {
//           return const Center(
//             child: Text('No reminders for this day'),
//           );
//         }
//
//     });
//     }
//   }
// }

  _showItems() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _itemController.itemsList.length,
            itemBuilder: (_, index) {
              int type = _itemController.itemsList[index]['type'];

              if (type == 1) {
                var medicine =
                    Medicine.fromJson(_itemController.itemsList[index]);
                return ReminderTile(
                  id: medicine.id as int,
                  title: medicine.title as String,
                  note: medicine.note as String,
                  date: medicine.date as String,
                  type: medicine.type as int,
                  dose: medicine.dose,
                  meal: medicine.meal,
                  sequence: medicine.sequence,
                );
              } else {
                var activity =
                    Activity.fromJson(_itemController.itemsList[index]);
                return ReminderTile(
                  id: activity.id as int,
                title: activity.title as String,
                  note: activity.note as String,
                  date: activity.date as String,
                  time: activity.time,
                  type: activity.type as int,
                );
              }
            });
      }),
    );
  }
}
