import 'package:avrod/generated/locale_keys.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationSV {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    var iosInitialize = const DarwinInitializationSettings(
    defaultPresentSound: true
    );
    var intInitializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(intInitializationSettings);
  }

  static Future showTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin flnp,
      
      }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      playSound: true,
      //sound: RawResourceAndroidNotificationSound("notification"),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics,
    iOS: const DarwinNotificationDetails(),
    
    );

    await flnp.show(0, title, body, not);
  }
}

List<String> titleList = [
  LocaleKeys.titlenotifi1,
  LocaleKeys.titlenotifi2,
  LocaleKeys.titlenotifi3,
  LocaleKeys.titlenotifi4,
  LocaleKeys.titlenotifi5,
  LocaleKeys.titlenotifi6,
  LocaleKeys.titlenotifi7,
  LocaleKeys.titlenotifi8,
  LocaleKeys.titlenotifi9,
  LocaleKeys.titlenotifi10,
  LocaleKeys.titlenotifi11,
];

List<String> bodyList = [
  LocaleKeys.bodynotifi1,
  LocaleKeys.bodynotifi2,
  LocaleKeys.bodynotifi3,
  LocaleKeys.bodynotifi4,
  LocaleKeys.bodynotifi5,
  LocaleKeys.bodynotifi6,
  LocaleKeys.bodynotifi7,
  LocaleKeys.bodynotifi8,
  LocaleKeys.bodynotifi9,
  LocaleKeys.bodynotifi10,
  LocaleKeys.bodynotifi11,
];
