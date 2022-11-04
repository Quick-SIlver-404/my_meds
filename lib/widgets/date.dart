import 'package:flutter/material.dart';
import 'package:my_meds/widgets/themes.dart';

class DateWidget extends StatelessWidget {
  final String? date;
  final DateTime? dateTime;
  final String? time;
  final bool isDate;

  const DateWidget({Key? key,
    this.date,
    this.dateTime,
    this.time,
    this.isDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon icon;
    String text;
    if(isDate){
        text = date as String;
        icon = const Icon(Icons.calendar_today_outlined);
    } else {
      text = time as String;
      icon = const Icon(Icons.access_time_rounded);
    }
    return Row(children: [
      icon,
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(text,
        style: MyTheme.noteStyle,),
      ),
    ],);
  }
}
