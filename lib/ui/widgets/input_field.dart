import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: Themes.titleStyle,),
            Container(
              padding: EdgeInsets.only(top: 8,left: 10),
              margin: EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width,
              height: 54,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey
                  )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Get.isDarkMode ? Colors.grey[200]:Colors.grey[700],
                   // readOnly: widget!=null ? true:false,
                    style: Themes.subTitleStyle,
                    controller: controller,
                    autofocus: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0
                        )
                      ),
                      hintText: hint,
                      hintStyle: Themes.subTitleStyle,
                    ),
                  ),
                  ),
                  widget ?? Container(),
                ],
              ),
            ),
          ],
        ),



    );
  }
}
