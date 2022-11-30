import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = "";

  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Center(
          child: Text(
            _payload.toString().split("|")[0],
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Column(
              children: [
                Text(
                  "Hello , Michael",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You have a new reminder",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryClr,
                ),
                padding: EdgeInsets.only(left: 20,right:20),
                margin: EdgeInsets.only(left: 20,right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),

                      Row(
                        children: [
                          Icon(Icons.text_format,color: Colors.white,size: 30,),
                          SizedBox(width: 10,),
                          Text("Title",style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("Put a Title Here",style: TextStyle(color: Colors.white),), //TODO

                      SizedBox(height: 30,),

                      Row(
                        children: [
                          Icon(Icons.description,color: Colors.white,size: 30,),
                          SizedBox(width: 10,),
                          Text("Description",style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("Put a Description Here",style: TextStyle(color: Colors.white,),textAlign: TextAlign.justify,), //TODO

                      SizedBox(height: 30,),

                      Row(
                        children: [
                        Icon(Icons.calendar_today_outlined,size: 30,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Date",style: TextStyle(color: Colors.white,fontSize: 30),)
                      ],
                      ),
                      SizedBox(height: 10,),
                      Text("Put a Date Here",style: TextStyle(color: Colors.white),), //TODO


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
