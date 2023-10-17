import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/controllers/data_uploader.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/core/notify_helper.dart';
import 'package:avrod/routes.dart';
import 'package:avrod/screens/uploder_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'colors/theme.dart';
import 'generated/codegen_loader.g.dart';
import 'package:timezone/data/latest.dart' as tz;

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
          // ChangeNotifierProvider<DataUploaderController>(
          //   lazy: false,
          //   create: (context) => DataUploaderController(c),
          // ),
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




// const credentials = '''{
//   "type": "service_account",
//   "project_id": "azkar-4a452",
//   "private_key_id": "78c040463f0ddcc06fed6ff7b99752559808b984",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCu+UVTHOEsGQ8Q\nmVL29i8NcyZ8ID5XBQe43ZlmL13JdFNP0lnQTOjX/xVuZ3J/cnPQoW5QATxXQmy4\nmtyxXrpbxkZClXWiNcAuOH8NiJmIym+drywBEhn4Q6UT10Y82FlqzTIpGr4nx69V\nZ+57do72Q/5dCoiCqPojS7eXXcUJxcYIenqYMy70VfpIpLj0NJk2OpuQbOk/VKqQ\ntKgAbTE9gNWmGMofB1fYrpAw5PVp2Ljqv0KWNZjc6cju4FQ92YvxuJMGXpzl3/ct\nRJ+V46x0g5Tb05PyZuNW6aEXiRHZy/rki1Jn0Be6I0Rwh7+ravocTyK5VVxeilP2\nSoL4Tn5zAgMBAAECggEAJnqqLLt6p3SBVCCr1qTQNzB+I6kBnKh+CMEvBYJgKTf8\nRF8Zok3vnOS7hVKZov58CsMdm9mRuAzjFPv1kconyJwDgowU2Q3iDCgfhM3oGeWP\nA0ntLvUYofjaWlEq4KGhlHO41sJLVDs9S1Z2Y09w5CaSz0pMOBPKIq35m3+jH+Ex\n2m3vnBaentEK9yWQDr4HgtUUXHHd8rPBwzVNnT2IKrnPITB6iijf4AKLyhdjQ9s/\nhEf1MNc3GFA0jkbvXiksJLsuufmtojIRr+TU5ER5hy2PVptqh40gPWBzod83axg5\nJFnqH+4W++ogVB5HuJsWjIIFAuvy/YIuQ8Wk/n3boQKBgQDdngBKINcBzQGQvhrl\np8ngVxwSUwPO0OX/tdCMCLBybC1GHTyMSk2CgJpFR33TkLf37dGK55bvItQhFMCi\nQjsOG4deynplzwxxLDqH4+U5V0bU7FLAQwmmqYfc5PJzrB3UcnGC/Nq5jh9+gxzH\nCiFTLdDsTyqGijncetBMNGwnoQKBgQDKHrl+YWJKs9O8mn0M9WXFVZVvE1PVsJfr\nzcEuxvxjukxFlMATQtGLpmvq+9G8Tieu9WyoHfJwt9US9ZozHRCeQTRiXm6b0l3V\nB4pFAVvJHekkXGibAYMp0o4cJqwokX5LT2arGv0PfA8Q0WwleR8bxU0HOuS82Out\nobirqCadkwKBgQCT4rzEurdfX0M9KG7gc6A2UUrNO5Jd726bveMFn0LHiEKJ+DaQ\nU4D3pgPMWVGw3XC2RH/BFpvUxkQSMzv8yv+HgX1LFwioaYse9mm0hrJPGluM+Iqb\n++Az1Atyr2DPKbraKuhuhXcbvahsjuekNrFYRUmWd5mkIBdOdrILOCw4IQKBgQCM\nas//hvRcZZYiH0nlKM8tSwnoAwtpF6hTv7wIHWHWfuTiKjdOqksds96hf5T0N2/G\nUubL3RJDUNOMumgIPpb++tnDxUseogViLDzZN9pmXItOIYzisyhGc+saj5tnC70r\n4Nu436UTjuKAkp2JYx5Dksyyyy2CLUl+dS3ww38gVQKBgBs9t56pZD5O6cj6sISN\nYAdImQLNQHUdHVPm21jmLZbpGYTQ56WfgGHZGnyZp1U6+LNvWF72pUo0l1Zj/C0n\nX6gO1pPo68Qtk/w/ULi8U3f9uripXLZdZs30bZp5un0aeu60o2YqM7UEgjCS/1Nl\n7Sr4AWv/GvcC/4ww/Cq7YV3t\n-----END PRIVATE KEY-----\n",
//   "client_email": "azkar-960@azkar-4a452.iam.gserviceaccount.com",
//   "client_id": "117490652731857972167",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/azkar-960%40azkar-4a452.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }''';

// const _docsId = "1FVyD2oYSMdmZEIpYJYGUKXhvctAcrQ2qRge4qv7HoqE";