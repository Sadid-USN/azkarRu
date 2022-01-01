// @dart=2.9
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/screens/home_page.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/book_map.dart';

// ignore: constant_identifier_names
const String FAVORITES_BOX = 'favorites_box';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().initNotification();
  // await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(FAVORITES_BOX);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return FutureBuilder<List<Book>>(
          future: BookFunctions.getBookLocally(context),
          builder: (context, snapshot) {
            return Provider<List<Book>>(
              create: (_) {
                return snapshot.data;
              },
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  textTheme: GoogleFonts.ptSerifCaptionTextTheme(
                      Theme.of(context).textTheme),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: snapshot.data == null
                    ? Scaffold(
                        body: Center(
                            child: JumpingText(
                          '...',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.green),
                        )),
                      )
                    : const HomePage(),
              ),
            );
          },
        );
      },
    );
  }
}
