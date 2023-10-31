import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/controllers/data_uploader.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/controllers/library_controller.dart';
import 'package:avrod/controllers/radio_conteroller.dart';
import 'package:avrod/core/notify_helper.dart';
import 'package:avrod/firebase/firebase_messagin.dart';
import 'package:avrod/routes.dart';
import 'package:avrod/screens/uploder_screen.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'colors/theme.dart';
import 'generated/codegen_loader.g.dart';
import 'package:timezone/data/latest.dart' as tz;

const String FAVORITES_BOX = 'favorites_box';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await NotificationHelper().initNotification();
  await MobileAds.instance.initialize();
  await FirebaseMessaginApi().initNotification();

  // CoordinatesInit().initCoordinates();

  await GetStorage.init();

  // FirebaseDatabase.instance.setPersistenceEnabled(true);
  await EasyLocalization.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Hive.initFlutter();

  await Hive.openBox('pageBox');
  await Hive.openBox(FAVORITES_BOX);

  Locale? startLocale = await getSavedLocale();
  startLocale ??= WidgetsBinding.instance.platformDispatcher.locale;
  final Connectivity connectivity = Connectivity();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('fr'),
      ],
      assetLoader: const CodegenLoader(),
      path: 'assets/translations',
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<DataUploaderController>(
            create: (context) => DataUploaderController(context),
          ),
          ChangeNotifierProvider<AudioController>(
            lazy: true,
            create: (context) => AudioController(),
          ),
          ChangeNotifierProvider<LibraryController>(
            lazy: false,
            create: (context) => LibraryController(),
          ),
          ChangeNotifierProvider<RadioController>(
            lazy: false,
            create: (context) => RadioController(),
          ),
          ChangeNotifierProvider<InternetConnectionController>(
            lazy: true,
            create: (context) => InternetConnectionController(connectivity),
          ),
          // Add other providers here
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
         // home: const DataUploadedScreen(),
        routes: appRoutes,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: appTheme,
        );
      },
    );
  }
}

Future<Locale?> getSavedLocale() async {
  final box = await Hive.openBox("app_locale");
  final savedLocale = box.get('app_locale');
  return savedLocale != null ? Locale(savedLocale) : const Locale("en");
}
