import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/ui/theme.dart';

import '../../models/task.dart';
import '../size_config.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, {Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return Container(
      width: orientation == Orientation.landscape
          ? mediaQuery.size.width / 2
          : mediaQuery.size.width,
      padding: EdgeInsets.symmetric(
        horizontal:
          orientation == Orientation.landscape ? 4 : 10,

     ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: getBGCLr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${task.startTime} - ${task.endTime}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    task.note!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                ],
              ),
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'ToDO' : 'Completed',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBGCLr(int? color) {
    switch (color) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.pink;
      case 2:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
