// This file contains the parent class for the medicine and activity class

class Item {
  String? title;
  String? note;
  String? date;
  int? id;
  int? type; // Type 1 = Medicine, Type 2 = Activity

  Item({required this.title, required this.note, required this.date, this.id, this.type});

  Item.fromJson(Map<String, dynamic> json){
    title = json['title'];
    note = json['note'];
    date = json['date'];
    id = json['id'];
    type = json['type'];
  }
  
}
