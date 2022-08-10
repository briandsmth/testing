import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_app/method/firestore_method.dart';
import 'package:mini_app/widgets/button_login.dart';
import 'package:mini_app/widgets/text_input.dart';

class DetailTaskScreen extends StatefulWidget {
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String taskId;
  const DetailTaskScreen(
      {Key? key,
      required this.title,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.taskId})
      : super(key: key);

  @override
  State<DetailTaskScreen> createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final TextEditingController titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = 'Select end Time';

  getDateFromUser() async {
    DateTime? _pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2200));

    if (_pickDate != null) {
      setState(() {
        _selectedDate = _pickDate;
      });
    } else {
      print('something wrong');
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time cancel');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            color: Colors.blue,
          ),
          title: Text(
            'Edit Task',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputText(
                title: 'Title',
                hint: widget.title,
                controller: titleController,
              ),
              InputText(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      getDateFromUser();
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputText(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: InputText(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Button(
                  text: 'Update Task',
                  onPress: () {
                    FirestoreMethods().updateTask(
                        titleController.text,
                        _startTime,
                        _endTime,
                        _selectedDate.toString(),
                        widget.taskId);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
