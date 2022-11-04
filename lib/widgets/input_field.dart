import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {super.key,
        required this.title,
        required this.hint,
        this.controller,
        this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor:
                    Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
                    controller: controller,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? Colors.grey[100]
                            : Colors.grey[400]),
                    decoration: InputDecoration(
                        hintText: hint,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.scaffoldBackgroundColor,
                                width: 0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.scaffoldBackgroundColor,
                                width: 0)),
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Get.isDarkMode
                                ? Colors.grey[100]
                                : Colors.grey[400])),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                  child: widget,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
