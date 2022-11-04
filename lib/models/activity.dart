import 'item.dart';

class Activity extends Item {
  String time;

  Activity(
      {required super.title,
        required super.note,
        required super.date,
        required this.time,
        super.type = 2});

  Activity.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        super.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    data['time'] = time;
    data['type'] = type;
    return data;
  }

  DateTime getDateTime(){
    List<String> dateList = (date as String).split('/');
    print(dateList);
    int year = int.parse(dateList[2]);
    int month = int.parse(dateList[0]);
    int day = int.parse(dateList[1]);

    String monthStr = '$month';
    if(month < 10){
      monthStr = '0$month';
    }
    String dayStr = '$day';
    if(day < 10){
      dayStr = '0$day';
    }

    String dateStr = '$year-$monthStr-$dayStr';

    List<String> timeStr = time.split(' ');
    int hour = int.parse(timeStr[0].split(':')[0]);
    int minute = int.parse(timeStr[0].split(':')[1]);


    if(timeStr[1] == 'PM')
    {
      hour += 12;
    }

    String hourStr = hour.toString();


    if(hour < 10){
      hourStr = '0$hour';
    }

    String minStr = minute.toString();
    if(minute< 10){
      minStr = '0$minStr';
    }

    var timeString = '$hourStr:$minStr:00';

    DateTime dateTime = DateTime.parse('$dateStr $timeString');

    return dateTime;
  }


}
