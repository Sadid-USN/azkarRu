// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';

// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_timezone;

// void selectNotification(NotificationResponse details) {
//   if (details.payload != null) {
//     print("Notification payload ${details.payload}");
//   } else {
//     print("Notification done");
//   }
//   print("Go to the page");
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class NotificationHelper {
//   Future<void> initNotification() async {
//     await _configureLocalTimeZone();
//     print("Notification successfully initialized");
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('@drawable/ic_launcher');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {},
//     );

//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();

//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {},
//       onDidReceiveBackgroundNotificationResponse: selectNotification,
//     );
//   }

//   notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'com.darulasar.Azkar',
//         'Azkar',
//         icon: "@drawable/ic_launcher",
//         importance: Importance.max,
//         sound: RawResourceAndroidNotificationSound("azan"),
//       ),
//       iOS: DarwinNotificationDetails(
//         threadIdentifier: "com.darulasar.Azkars-en",
//         sound: "azan",
//       ),
//     );
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return flutterLocalNotificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required int hour,
//     required int minutes,
//     required String parayName,
//     required String body,
//   }) async {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduleDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minutes,
//     );
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(hours: 1));
//     }

//     return flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       parayName,
//       body,
//       scheduleDate,
//       await notificationDetails(),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   // tz.TZDateTime _convertTime(int hour, int minuts) {
//   //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   //   tz.TZDateTime scheduleDate = tz.TZDateTime(
//   //     tz.local,
//   //     now.year,
//   //     now.month,
//   //     now.day,
//   //     hour,
//   //     minuts,
//   //   );
//   //   if (scheduleDate.isBefore(now)) {
//   //     scheduleDate = scheduleDate.add(const Duration(hours: 1));
//   //   }
//   //   return scheduleDate;
//   // }

//   Future<void> _configureLocalTimeZone() async {
//     tz_timezone.initializeTimeZones();
//     final timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZone));
//   }
// }

 // final NotificationHelper _notificationHelper = NotificationHelper();

  // Future<void> _schedulePrayerNotifications(
  //     Timings prayerTimings, String currentDate) async {
  //   if (currentDate != DateFormat('dd-MM-yyyy').format(dateForfam)) {
  //     // Если данные о времени молитвы не актуальны для текущей даты, перезагрузагружаем
  //        final possition = await determinePosition();
  //     final PrayersModel newData = await PrayersApi().getPrayerTimes(
  //         context: context,
  //         capital: capital,
  //         country: country,
  //         latitude: possition.latitude,
  //         longitude: possition.longitude,
  //         date: formattedDate);
  //     prayStorage.write('prayer_data', newData.toJson());
  //     prayerTimings = newData.data!.timings!;
  //   }
  //   int id = Random().nextInt(10000);

  //   final Map<String, String> timingsMap = {
  //     LocaleKeys.fajr.tr(): prayerTimings.fajr??  "19:04",
  //     LocaleKeys.duhr.tr(): prayerTimings.dhuhr ?? "_",
  //     LocaleKeys.asr.tr(): prayerTimings.asr ?? "_",
  //     LocaleKeys.maghrib.tr(): prayerTimings.maghrib ?? "_",
  //     LocaleKeys.isha.tr(): prayerTimings.isha ?? "_",
  //   };

  //   for (var prayerName in timingsMap.keys) {
  //     final prayerTime = timingsMap[prayerName]!.split(':');
  //     final hour = int.parse(prayerTime[0]);
  //     final minutes = int.parse(prayerTime[1]);

  //     await _notificationHelper.scheduleNotification(
  //       id: id,
  //       //id: notificationId++,
  //       hour: hour,
  //       minutes: minutes,
  //       parayName: prayerName,
  //       body:
  //           '${LocaleKeys.itsTimeFor.tr().capitalize()} ${prayerName.capitalize()}',
  //     );
  //   }
  // }
