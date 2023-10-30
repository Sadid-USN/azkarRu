import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Body: ${message.notification!.body}");
  print("Title: ${message.notification!.title}");
  print("Data: ${message.data}");
}

class FirebaseMessaginApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await messaging.requestPermission();
    String? fcmToken = await messaging.getToken();
    print("FCM Token: ----> $fcmToken");
    FirebaseMessaging.onMessageOpenedApp;
   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  //
}
