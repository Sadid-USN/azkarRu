import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/controllers/data_uploader.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/controllers/library_controller.dart';
import 'package:avrod/controllers/radio_conteroller.dart';
import 'package:avrod/core/notify_helper.dart';
import 'package:avrod/routes.dart';
import 'package:avrod/screens/uploder_screen.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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

// const credentials = '''{
//   "type": "service_account",
//   "project_id": "azkar-de3a2",
//   "private_key_id": "f1166285ae8d9987a68235b06fb23e7a2074a806",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3v7OFFmzcWW4E\nSdAcVXBLYfo7sBZvInavKoaWOe+aqsZQzbQouUvVakmF/FuwnpegMEvVIyuXt3qV\nLPu13p8Wv1h6qrhIJRCsiuf2ddV4go8NO831ppKc5b5++q0maUJTJqMtttBlyyja\nLrGaEUATdIj1Sax3x0rmBchBaqk364+yMluPuuYJw5j7npUk0EHH695xo4xNSiH2\nB7kACZcI750LHWihly8jP8YYEw+9lUah79N3r4Ox5LBy1sMSckcV3v0CG9FjufBf\nhv8ZC4SKZHyfGXQHTluOSP4RKdceGxjyIDWbzDX5FXUdV8RsW3njLsJezjKJp+ss\nj8ys/Yw3AgMBAAECggEAN8D5qjjHOEcEbFWvSWGdTKpCgMjpzbfh1j2rj7qtmrsV\nqJ/5+d9bhLqW64pKkflVHZx57gaZbBQWpFv9Vk5h7EeMA9B4UR+6Avi08KIJb2MC\nH+xVDqQH2YaWejX6wuxuXQecvLq7Wh++WhGP/yUb0atrAS5lIAT/E3OOs1a3WMlj\nkfEHJcVXnTw/IlVqzKiIOhu5/OOaMcdmaJhLLo42QXBq+Qb0mRBhIg+CE5SJrKj3\nWC3zYORac1J3AK/nQBXGzVAmh6rtvwJgjphRtk/CvyzArS3+FQSXbE1gwE8jA7u0\nQ2550+dmWoTCBsnjbPagEvL/A/7iSOkphugIx3zgPQKBgQDqT/+n7g00BcFVzoDb\nmWLfB+P3agVbWvUUouIFDbSyrZrb/PxGN5d+C3HeZXirCG74hkmkUYZwrkEBnNK3\na1VyoVnF4qyeAWz/dqjvJGeNdsNAzrJBtMcGmpe9cuLq4WPUWPsWdyw+qmElzzEQ\nkZw+4AzXmljiVyfFs2+ggDE/qwKBgQDIwZqSbtCLxFMNkbD1qEx5wO0ax9I2durS\ngUIeOJDB1YARnplamDqCWW7A90uzGXdVBpclnjymmJh8LrXbnwPEKY6y5jsJn1vi\n9hpqrm17nmOW/9cs0z5+QjE9+GadGqzNO0RS/KzCWj6CJjzD7DqUVDq+lBsd0zq7\ncCHyXYeJpQKBgQDD8GoF8BeybS2jp7Ax8y6u+1YzS8F3B7TysNL5DuEQmgRp+kCs\nJ0jT6pYqOAiUXdUOlp12f4ZBLDbINnAvWd52oV8FD+zxpJeVeZEDihnePnZA95gx\nQg89AoHptuzzJc/pfw9ZVgb10Fy01XJePKXAHnQex7+UZvWnacnrGcgVSQKBgD24\nsEI3Caz+9h3k3ggY7zI7q2ohZzLRis6faOmLsI23i0FfhnyA8vQidNek8EQnHzYn\n6Y5qQPFjVvZPEiBsmibUNAgympIRyZlU2rhT2ls4ThwdmlUwuTTuOt93oGzKx7ft\nccsl3iN+xVsUUHhYB4aVAt6XAGNCDvuTtQwjz0j1AoGAJAvBc9QcuDWPq3oRmCUk\nLXX+PqeA4yqBQU+vQWbL1TrqqzgHXDYbCbppFQ43XIyMHR5N++AcrH/venL7cpgy\nuBd6PHocAAF3k4HpQk9rUlyp/Kr6QXppxrAJhVX4O4BE91oErGjJT8g9nJOsdcTN\nq1JHOMgYhyWqMN6lTxHaYbY=\n-----END PRIVATE KEY-----\n",
//   "client_email": "azkar-library@azkar-de3a2.iam.gserviceaccount.com",
//   "client_id": "105796456680463752282",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/azkar-library%40azkar-de3a2.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }''';

// const ssId = "1NUaa_QNY9mopiYGKbDvMPsqutZWdtnkiAwGLWhGw0I4";

// ignore: constant_identifier_names
const String FAVORITES_BOX = 'favorites_box';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // CoordinatesInit().initCoordinates();
  await NotificationHelper().initNotification();
  await MobileAds.instance.initialize();

  await GetStorage.init();
  await Firebase.initializeApp();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  await EasyLocalization.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  tz.initializeTimeZones();
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
