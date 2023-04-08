import 'package:avrod/generated/locale_keys.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, int time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: time)),
        const NotificationDetails(
          android: AndroidNotificationDetails('channel id', 'channel name',
              channelDescription: 'Main channel notifications',
              sound: RawResourceAndroidNotificationSound('notification_sound'),
              playSound: true,
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/ic_flutternotification'),
          iOS: IOSNotificationDetails(
            sound: 'notification_sound',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> dailyAtNotification(
      int id, String title, String body, int time) async {
    //   var time = const Time(19, 25, 0);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.local(1).add(const Duration(days: 1)),
        const NotificationDetails(
          android: AndroidNotificationDetails('channel id', 'channel name',
              channelDescription: 'Main channel notifications',
              sound: RawResourceAndroidNotificationSound('notification_sound'),
              playSound: true,
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/ic_flutternotification'),
          iOS: IOSNotificationDetails(
            sound: 'notification_sound',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);

    // Future<void> cancelAllNotifications() async {
    //   await flutterLocalNotificationsPlugin.cancelAll();
    // }
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
