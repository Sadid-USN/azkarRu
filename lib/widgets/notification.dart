import 'package:avrod/generated/locale_keys.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;




class LocalNotificationSV {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification({
  int id = 0,
  String? title,
  String? body,
  String? payload,
  required DateTime scheduledNotificationDateTime,
}) async {
  var notificationTime = DateTime(
    scheduledNotificationDateTime.year,
    scheduledNotificationDateTime.month,
    scheduledNotificationDateTime.day,
    11, // Установка часа на 9
    21, // Установка минут на 0
  );

  return notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(notificationTime, tz.local),
    await notificationDetails(),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
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
