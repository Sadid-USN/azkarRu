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
  "Здоровое сердце!",
  "Милосердие",
  "Истинный мусульманин",
  "Сияющее лицо",
  "Родители!",
  "Говори благое",
  "Почитание соседа",
  "Всевышний Аллах сказал",
  "Всевышний Аллах сказал",
  "Всевышний Аллах сказал",
  "Защита в поминании",
];

List<String> bodyList = [
  "О Аллах, поистине, я молю Тебя сделать моё сердце здравым!",
  "Кто не милует, не будет помилован Аллахом. (Муслим)",
  "Мусульманин – это тот, от чьих рук и языка находятся в безопасности другие мусульмане",
  "Улыбка в лицо твоего брата есть садака",
  "Довольство Аллаха в довольстве родителей. Гнев Аллаха в гневе родителей (Тирмизи)",
  "Пусть тот, кто верует в Аллаха и в Последний день, говорит благое или молчит",
  "Поминайте Меня, и Я буду помнить о вас. (Аль-Бакара:152)",
  "О те, которые уверовали! Поминайте Аллаха многократно (Аль-Ахзаб:41).",
  "и часто поминающих Аллаха мужчин и женщин, Аллах уготовил прощение и великую награду. (Аль-Ахзаб:35)",
  "Разве не поминанием Аллаха утешаются сердца? (Ар-Раад:35)",
  "Раб (Аллаха) защищён от того, что исходит от шайтана, пока поминает Всевышнего Аллаха",
];
