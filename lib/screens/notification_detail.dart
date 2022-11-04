import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:my_meds/models/activity.dart';
// import 'package:my_meds/utilities/medicine_controller.dart';
//
// import '../models/medicine.dart';
import '../utilities/db_helper.dart';

class NotificationDetails extends StatelessWidget {
  final String title;
  final String note;
  final int id;

  const NotificationDetails(
      {super.key, required this.title, required this.note, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
          ),
          Text(note),
          const SizedBox(
            height: 75,
          ),
          // ),
          // const Spacer(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff01a87d),
                      ),
                      child: const Text('Skip'))),
              const Spacer(),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        DBHelper.reduceDose(id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff01a87d),
                      ),
                      child: const Text("Done"))),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
