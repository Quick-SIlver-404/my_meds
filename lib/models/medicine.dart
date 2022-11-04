import 'item.dart';

class Medicine extends Item {
  int meal;
  int sequence;
  int dose;

  Medicine(
      {required super.title,
        required super.note,
        required super.date,
        required this.meal,
        required this.sequence,
        required this.dose,
        super.id,
        super.type = 1});

  Medicine.fromJson(Map<String, dynamic> json)
      : dose = json["dose"],
        meal = json['meal'],
        sequence = json['sequence'],
        super.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    data['dose'] = dose;
    data['meal'] = meal;
    data['sequence'] = sequence;
    data['type'] = type;
    return data;
  }

  DateTime getDateTime(){
    print('date: $date');
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

    String timeStr;

    switch(meal){
      case 0:
        timeStr = '09:00:00';
        break;
      case 1:
        timeStr = '15:00:00';
        break;
      default:
        timeStr = '19:00:00';
    }
    DateTime result = DateTime.parse('$dateStr $timeStr');
    return result;
  }


}

enum Meals { breakfast, lunch, dinner }

enum Sequence { after, before }
