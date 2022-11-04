import 'package:flutter/material.dart';
import 'package:my_meds/screens/more/LanguageDialog.dart';
import 'package:my_meds/screens/more/contactSMS.dart';
import 'package:get/get.dart';
import 'package:my_meds/screens/more/search.dart';
import 'package:my_meds/screens/more/shareMedication.dart';
import 'package:share_plus/share_plus.dart';

class More extends StatelessWidget {
  const More({super.key});
  final String dummy = 'Medication list';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.contact_phone),),
          title:   Text('${'Contact and SMS'.tr}'),
          subtitle:   Text('${'Send SMS to your close ones'.tr}'),
          onTap: () {
            Get.to(ImportContact());
          },
        ),
        ListTile(
          
          leading: const CircleAvatar(child: Icon(Icons.share)),
          title:  Text('${'Share Medication'.tr}'),
          subtitle:  Text('${'Share your medication details'.tr}'),
          onTap: () {                
            shareMed();
          },
    ),
            ListTile(
          
          leading: const CircleAvatar(child: Icon(Icons.search)),
          title:  Text('${'Search Medicine'.tr}'),
          subtitle: Text('${'Find more information about the medicine'.tr}'),
          onTap: () {                
            Get.to(WebSearch());
          },
    ),

        ListTile(

          leading: const CircleAvatar(child: Icon(Icons.language_outlined)),
          title:  Text('${'Change language'.tr}'),
          subtitle: Text('${'Pick your preferred language'.tr}'),
          onTap: () {
            Get.to(SelectLanguage());
          },
        ),
        ],
      );
  }
}

