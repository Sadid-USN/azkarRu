import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_timezone;

void selectNotification(NotificationResponse details) {
  if (details.payload != null) {
    print("Notification payload ${details.payload}");
  } else {
    print("Notification done");
  }
  print("Go to the page");
}

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isSoundEnabled = false;
  Future<void> initNotification() async {
    _configureLocalTimeZone();
    print("Notification successfully initialized");
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
      onDidReceiveBackgroundNotificationResponse: selectNotification,
    );
  }

  notificationDetails(bool isSoundEnabled) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'com.darulasar.Azkar',
          'Azkar',
          icon: "mipmap/ic_launcher",
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound(
              isSoundEnabled ? "azan" : "--"),
        ),
        iOS: const DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails(false));
  }

  Future scheduleNotification(
      {
      required int id,
      required bool isSoundEnabled,
      required int hour,
      required int minutes,
      required String parayName,
      required String body}) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(hours: 1));
       return;
    }

    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      parayName,
      body,
      scheduleDate,
      await notificationDetails(isSoundEnabled),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // tz.TZDateTime _convertTime(int hour, int minuts) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduleDate = tz.TZDateTime(
  //     tz.local,
  //     now.year,
  //     now.month,
  //     now.day,
  //     hour,
  //     minuts,
  //   );
  //   if (scheduleDate.isBefore(now)) {
  //     scheduleDate = scheduleDate.add(const Duration(hours: 1));
  //   }
  //   return scheduleDate;
  // }

  Future<void> _configureLocalTimeZone() async {
    tz_timezone.initializeTimeZones();
    final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

//   Future scheduleNotification({
//   int id = 0,
//   String? title,
//   String? body,
//   String? payload,
// }) async {
//   final now = DateTime.now();
//   final scheduledTime = now.add(const Duration(seconds: 5));

//   var notificationTime = tz.TZDateTime.from(
//     scheduledTime,
//     tz.local,
//   );

//   return notificationsPlugin.zonedSchedule(
//     id,
//     title,
//     body,
//     notificationTime,
//     await notificationDetails(),
//     androidScheduleMode: AndroidScheduleMode.exact,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//   );
// }
}
