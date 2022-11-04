import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../utilities/medicine_controller.dart';
import '../widgets/input_field.dart';
import '../models/medicine.dart';

String debugTag = "AddItem";

class AddItem extends StatefulWidget {
  final bool isForMedicine;

  const AddItem({super.key, required this.isForMedicine});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  bool _isForMedicine = true;

  final ItemController _medicineController = Get.put(ItemController());
  final _titleEditingController = TextEditingController();
  final _noteEditingController = TextEditingController();
  final _doseEditingController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedTime =
      DateFormat("hh:mm a").format(DateTime.now()).toString();

  final _mealList = ['Breakfast', 'Lunch', 'Dinner'];

  final _sequenceList = ['After', 'Before'];
  String _selectedMeal = 'Breakfast';
  String _selectedSequence = 'Before';
  int _selectedDose = 0;

  @override
  void initState() {
    _isForMedicine = widget.isForMedicine;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Is for medicine: $_isForMedicine');
    return Scaffold(
      appBar: AppBar(
        title: _isForMedicine
            ? const Text('Add Medicine')
            : const Text('Add Activity'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyInputField(
                title: 'Title',
                hint: 'Enter a name',
                controller: _titleEditingController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteEditingController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Visibility(
                visible: !_isForMedicine,
                child: MyInputField(
                  title: 'Time',
                  hint: _selectedTime,
                  widget: IconButton(
                    onPressed: () {
                      _getTimeFromUser();
                    },
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: _isForMedicine,
                  child: MyInputField(
                    title: 'Available dose',
                    hint: '0',
                    controller: _doseEditingController,
                  )),
              Visibility(
                visible: _isForMedicine,
                child: Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                      title: 'Time to take:',
                      hint: _selectedSequence,
                      widget: DropdownButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        items: _sequenceList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            _selectedSequence = value as String;
                          });
                        },
                      ),
                    )),
                    Expanded(
                        child: MyInputField(
                      title: '',
                      hint: _selectedMeal,
                      widget: DropdownButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        items: _mealList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            _selectedMeal = value as String;
                          });
                        },
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _validateData();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff01a87d),
                        ),
                        child: const Text('Add')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        print(_selectedDate);
      });
    } else {}
  }

  _getTimeFromUser() async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      print("Time canceled");
    } else {
      setState(() {
        String formattedTime = pickedTime.format(context);
        _selectedTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    print("${debugTag} : Opened time picker");
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_selectedTime.split(":")[0]),
            minute: int.parse(_selectedTime.split(":")[1].split(' ')[0])));
  }

  _validateData() {
    if (_titleEditingController.text.isNotEmpty &&
        _noteEditingController.text.isNotEmpty) {
      if (_isForMedicine) {
        print("Adding to medicine");
        _addMedicineToDB();
      } else {
        print("Adding to activities");
        _addActivityToDB();
      }
      Get.back();
    } else if (_titleEditingController.text.isEmpty ||
        _noteEditingController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff01a87d),
          icon: const Icon(Icons.warning_amber_rounded));
    }
  }

  _addMedicineToDB() async {
    int? value = await _medicineController.addMedicine(
        medicine: Medicine(
      title: _titleEditingController.text,
      note: _noteEditingController.text,
      date: DateFormat.yMd().format(_selectedDate),
      meal: _getMeal(_selectedMeal),
      sequence: _getSequence(_selectedSequence),
      dose: int.parse(_doseEditingController.text),
    ));
    print("Medicine stored in id : $value");
  }

  _getMeal(String selectedMeal) {
    switch (selectedMeal) {
      case 'Breakfast':
        return Meals.breakfast.index;
      case 'Lunch':
        return Meals.lunch.index;
      case 'Dinner':
        return Meals.dinner.index;
    }
  }

  _getSequence(String selectedSequence) {
    if (selectedSequence == 'After') {
      return Sequence.after.index;
    } else {
      return Sequence.before.index;
    }
  }

  void _addActivityToDB() async {
    int? value = await _medicineController.addActivity(
        activity: Activity(
      title: _titleEditingController.text,
      note: _noteEditingController.text,
      date: DateFormat.yMd().format(_selectedDate),
      time: _selectedTime,
    ));
    print("Activity stored in id : $value");
  }
}
