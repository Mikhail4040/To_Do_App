import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';

import 'controllers/task_controller.dart';
import 'db/db_helper.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/notification_screen.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
 NotifyHelper().initializeNotification();
 await GetStorage.init();
 await DBHelper.initDb();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
 // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
