import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:my_meds/screens/notification_detail.dart';
import 'package:my_meds/utilities/medicine_controller.dart';

import '../models/activity.dart';
import '../models/medicine.dart';

class NotificationController extends GetxController {
  void sendNotification(
      {Medicine? medicine,
      Activity? activity,
      required DateTime dateTime,
      required int id}) async {
    print('Sending notifications');
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    if (medicine != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'scheduled',
              title: medicine.title,
              body: 'Time to take your meds',
              payload: {'id': id.toString(),
                'title': medicine.title,
                'note': medicine.note,
              }),
          // schedule: NotificationCalendar.fromDate(date: dateTime),
          actionButtons: [
            NotificationActionButton(key: 'cancel', label: 'Skip'),
            NotificationActionButton(key: 'success', label: 'Done')
          ]);
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'scheduled',
              title: activity!.title,
              body: activity.note,
              payload: {'id': id.toString(),
              'title' : activity.title,
                'note': activity.note
              }),
          actionButtons: [
            NotificationActionButton(key: 'cancel', label: 'Skip'),
            NotificationActionButton(key: 'success', label: 'Done')
          ]);

      // schedule: NotificationCalendar.fromDate(date: dateTime));
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification created');
    Get.snackbar('Notification Scheduled',
        'You will receive notification when it is time.');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    // Get.dialog(const Text("data"));
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    var payload = receivedAction.payload;
    if (payload != null) {
      int id = int.parse(payload['id'] as String);
      String title = payload['title'] as String;
      String note = payload['note'] as String;

      print('Notification id : $id');
      // var activity = await _itemController.getSpecificItem(id) as Activity;
      Get.to(() => NotificationDetails(id: id, title: title, note: note));
      print('End of method');
    }
    // var Activity = ItemController().getSpecificItem()
    // Get.defaultDialog(
    //   title:
    // );
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }
}
