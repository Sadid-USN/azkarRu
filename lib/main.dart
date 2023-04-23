// @dart=2.9
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/screens/home_page.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/book_map.dart';
import 'generated/codegen_loader.g.dart';

// ignore: constant_identifier_names
const String FAVORITES_BOX = 'favorites_box';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(FAVORITES_BOX);

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ru'),
        ],
        assetLoader: const CodegenLoader(),
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        saveLocale: true,
        child: ChangeNotifierProvider(
            create: (context) => AudioController(), child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return FutureProvider<List<Book>>(
          create: (_) => BookFunctions.getBookLocally(context),
          initialData: null,
          child: Consumer<List<Book>>(
            builder: (context, bookList, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                  textTheme: GoogleFonts.ptSerifCaptionTextTheme(
                      Theme.of(context).textTheme),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: bookList == null
                    ? Scaffold(
                        body: Center(
                            child: JumpingText(
                          '...',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.green),
                        )),
                      )
                    : const HomePage(),
              );
            },
          ),
        );
      },
    );
  }
}
