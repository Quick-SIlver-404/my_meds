import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SelectLanguage extends StatelessWidget {
    SelectLanguage({Key? key}) : super(key: key);

    final List locale = [
      {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
      {'name': 'नेपाली', 'locale': Locale('ne', 'NP')},
      ];

   updateLanguage(Locale locale) {
     Get.back();
     Get.updateLocale(locale);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('English'),
            onTap: (){
              updateLanguage(locale[0]['locale']);
              print('${locale[0]['locale']}');
        },
      ),

        ListTile(
            title: Text('Nepali'.tr),
            onTap: (){
            updateLanguage(locale[1]['locale']);
            },
          ),
        ],
      ),
    );
  }
}



//   updateLanguage(Locale locale) {
//     Get.back();
//     Get.updateLocale(locale);
//   }
// //ChangeLanguageAlertDialog Start
//   ChangeLanguageAlertDialog(BuildContext context) {
// // set up the button
//     Widget okButton = TextButton(
//       child: Text("OK"),
//       onPressed: () {},
//     );
// // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: const Text('Choose Your Language'),
//       content: Container(
//           width: double.maxFinite,
//           child: ListView.separated(
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     child: Text(locale[index]['name']),
//                     onTap: () {
// // print(locale[index]['name']);
//                       updateLanguage(locale[index]['locale']);
//                     },
//                   ),
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return Divider(
//                   color: Colors.blue,
//                 );
//               },
//               itemCount: locale.length)),
//     );
// // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// //ChangeLanguageAlertDialog End
//
//
//
//
//
