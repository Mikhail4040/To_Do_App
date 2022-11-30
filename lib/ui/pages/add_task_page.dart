import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/widgets/button.dart';

import '../../models/task.dart';
import '../theme.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat('hh:mm').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: Themes.titleStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter Title Here",
                controller: titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter Note Here",
                controller: noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  onPressed: () {
                    getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: startTime,
                      widget: IconButton(
                        onPressed: () async{
                         var s=await getTimeFromUser(isStartTime: true);
                         print("THe is s $s");
                        },
                        icon: Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: endTime,
                      widget: IconButton(
                        onPressed: () {
                          getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$selectedRemind minutes early",
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: Themes.subTitleStyle,
                  onChanged: (int? value) {
                    setState(() {
                      selectedRemind = value!;
                    });
                  },
                  items: remindList.map((value) {
                    return DropdownMenuItem(
                        child: Text('$value'), value: value);
                  }).toList(),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: "$selectedRepeat ",
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: Themes.subTitleStyle,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRepeat = value!;
                    });
                  },
                  items: repeatList.map((value) {
                    return DropdownMenuItem(
                        child: Text('$value'), value: value);
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorPalette(),
                  MyButton(
                      label: "Create Task",
                      onTap: () {
                     //   taskController.addTask(task: )
                        print("${taskController.taskList.length}");
                        validateDate();
                        print(endTime);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() => AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 20,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  Column colorPalette() {
    return Column(
      children: [
        Text(
          "Colors",
          style: Themes.titleStyle,
        ),
        SizedBox(
          height: 5,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? Colors.orange
                      : index == 1
                          ? Colors.pink
                          : Colors.blue,
                  child: index == selectedColor
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  addTasksToDb() async {
    int value = await taskController.addTask(
      task: Task(
        title: titleController.text,
        note: noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(selectedDate),
        startTime: startTime,
        endTime: endTime,
        color: selectedColor,
        remind: selectedRemind,
        repeat: selectedRepeat,
      ),
    );
    print(value);
  }

  getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1015),
        lastDate: DateTime(2050));
    if (pickedDate != null)
      setState(() {
        selectedDate = pickedDate;
      });
    else
      print("Error");
  }

  getTimeFromUser({required bool isStartTime}) async {
    print("Hellllllllllllllllllllllllllo");
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))),
    );
    print("THe picked Time is $pickedTime");
    String formattedTime = pickedTime!.format(context);
    if (isStartTime) {

      setState(() {
        startTime = formattedTime;
       startTime=startTime.substring(0,5);
       print(startTime);
      });
    }
   else if (!isStartTime) {
      setState(() {
        endTime = formattedTime;
        endTime=endTime.substring(0,5);
      });
    }
    else
      print("Error");
    // print(" pickedTime!.format(context) is ${pickedTime.format(context)}");
    // print("startTime is $startTime");
    // print("endtime is $endTime");


  }

  validateDate() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      addTasksToDb();
      print("OOOOOOOOOOOOK");
      Get.back();
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
      Get.snackbar(
        "required",
        "You Should Fill all The Fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(
          Icons.warning_amber,
          color: Colors.red,
        ),
      );
    } else
      print("Error");
  }
}
