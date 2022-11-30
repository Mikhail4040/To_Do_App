import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:intl/intl.dart'
    '';
import 'package:todo/ui/size_config.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var con = TextEditingController();
  final TaskController taskController = Get.put(TaskController());

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    taskController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Orientation orientation = mediaQueryData.orientation;

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              addTaskBar(),
              addDateBar(),
              SizedBox(
                height: 6,
              ),
              showTasks(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() => AppBar(
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            // NotifyHelper().displayNotification(
            //     title: "Theme Changed",
            //     body: Get.isDarkMode ? 'Light Mode' : 'Dark Mode');
              // NotifyHelper().scheduledNotification();
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.cleaning_services_outlined,size: 35,),
            color: Colors.red,
            onPressed: (){
              taskController.DeleteAllTasks();
            },
          ),
          SizedBox(width: 10,),


          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 20,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  Container addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()).toString(),
                style: Themes.headingStyle,
              ),
              Text(
                "Today",
                style: Themes.subHeadingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
               print("ok1");
              })
        ],
      ),
    );
  }

  addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: DateTime.now(),
        dateTextStyle:
            TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        dayTextStyle:
            TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        monthTextStyle:
            TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            selectedDate = newDate;
            print(selectedDate);
          });
        },
      ),
    );
  }

  showTasks() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return Container(
      padding: EdgeInsets.only(top: 10),
     // margin: EdgeInsets.only(top: 10),
      height:orientation==Orientation.portrait? mediaQuery.size.height:200,
      width: 400,
      child: Obx((){
        if(taskController.taskList.isEmpty){
          return noTaskMsg(orientation);
        }
        else
        {
          print(taskController.taskList.length);
          return
            RefreshIndicator(
              onRefresh: ()async{
               await taskController.getTasks(); //TODO
              },
              child: ListView.builder(itemBuilder: (BuildContext context,index){
                var task= taskController.taskList[index];
                if(
                task.repeat=="Daily" || task.date==DateFormat.yMd().format(selectedDate) ||
                    (task.repeat=="Weekly" && selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays %7==0) ||
                    (task.repeat=="Monthly" && selectedDate.day == DateFormat.yMd().parse(task.date!).day)
                )
                {
                  print("Task Of Date Is ${task.date}");
                  var hour = task.startTime.toString().split(':')[0];
                  var minute=task.endTime.toString().split(':')[1];
                  debugPrint("My Hour Is $hour" );
                  NotifyHelper().scheduledNotification(int.parse(hour),int.parse(minute),task);
                  return  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(
                              context,
                              task,
                            ),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    ),
                  );
                }else
                return   Container();
              },
                itemCount: taskController.taskList.length,
                scrollDirection: orientation==Orientation.landscape?Axis.horizontal:Axis.vertical,
              ),
            );
        }
  }
      ),
    );
  }

  noTaskMsg(var orientation) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: ()async{
            await taskController.getTasks();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 200),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: orientation == Orientation.landscape
                    ? Axis.vertical
                    : Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "You do not have any task yet!\n add new tasks to make your days productive",
                      style: Themes.subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: mediaQueryData.size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose == true
                ? Themes.titleStyle
                : Themes.titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: mediaQuery.size.width,
          height: orientation == Orientation.landscape
              ? task.isCompleted == 1
                  ? mediaQuery.size.height * 0.6
                  : mediaQuery.size.height * 0.8
              : task.isCompleted == 1
                  ? mediaQuery.size.height * 0.30
                  : mediaQuery.size.height * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              ),
              task.isCompleted == 1
                  ? Container()
                  : buildBottomSheet(
                      label: "Task Competed",
                      onTap: () {
                        NotifyHelper().cancelNotification(task);

                        taskController.markTaskComplete(task.id!);
                        Get.back();
                      },
                      clr: primaryClr),
              buildBottomSheet(
                  label: "Delete Task",
                  onTap: () {
                    NotifyHelper().cancelNotification(task);
                    taskController.DeleteTasks(task);
                    Get.back();
                  },
                  clr: primaryClr),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              buildBottomSheet(
                  label: "Cancle",
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
