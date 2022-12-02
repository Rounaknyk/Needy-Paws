

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{

  late final _notification = FlutterLocalNotificationsPlugin();

  late int id;
  late String title, body, payload;

  NotificationApi({this.id = 0, required this.title,required this.body,required this.payload});

  Future showNotification() async {
      _notification.show(id, title, body, await notificationDetails(), payload: payload);
  }

  static Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        importance: Importance.max
      ),
    );
  }

}