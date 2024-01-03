import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/controllers/prayer_time_controller.dart';
import 'package:avrod/core/try_again_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/prayers_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({Key? key}) : super(key: key);

  @override
  _PrayerTimeScreenState createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  late final InternetConnectionController internetConnectionController;
  late final PrayTimeController prayTimeController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    final Connectivity connectivity = Connectivity();
    internetConnectionController = InternetConnectionController(connectivity);
    prayTimeController = PrayTimeController();

    // Start listening to network changes
    internetConnectionController.listenToNetworkChanges(context);
  }

  @override
  void dispose() {
    internetConnectionController.dispose();
    super.dispose();
  }

  final player = AudioPlayer();
  int notificationId = 0;
  bool isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: IconButton(
      //   onPressed: () {

      // _notificationHelper.showNotification();
      //   },
      //   icon: const Icon(Icons.notification_add),
      // )),
      backgroundColor: bgColor,
      body: Consumer<PrayTimeController>(
        builder: (context, value, child) => FutureBuilder<PrayersModel>(
          future: value.prayerModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return TryAgainButton(
                  errorTitle: snapshot.error.toString(),
                  onPressed: () {
                    value.fetchAndCacheData();
                  });
            } else if (snapshot.hasData) {
              final data = snapshot.data!.data;

              final prayerTimings = [
                LocaleKeys.fajr.tr(),
                LocaleKeys.duhr.tr(),
                LocaleKeys.asr.tr(),
                LocaleKeys.maghrib.tr(),
                LocaleKeys.isha.tr(),
                LocaleKeys.imsak.tr(),
                LocaleKeys.lastthird.tr()
              ];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              _TopHeader(
                                ignoring: value.isLoading,
                                title: data!.meta?.timezone ?? "null",
                                onTap: () {
                                  value.fetchAndCacheData();
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _SunriseCard(
                            sunrise: data.timings?.sunrise ?? "null",
                            sunset: data.timings?.sunset ?? "null",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _SalahCard(
                            label: prayerTimings[0],
                            time: data.timings!.fajr ?? "null",
                            icon: Image.asset(
                              "icons/timesalah.png",
                              height: 30,
                            ),
                          ),
                          _SalahCard(
                            label: prayerTimings[1],
                            time: data.timings!.dhuhr ?? "null",
                            icon: Image.asset(
                              "icons/timesalah.png",
                              height: 30,
                            ),
                          ),
                          _SalahCard(
                            label: prayerTimings[2],
                            time: data.timings!.asr ?? "null",
                            icon: Image.asset(
                              "icons/timesalah.png",
                              height: 30,
                            ),
                          ),
                          _SalahCard(
                            label: prayerTimings[3],
                            time: data.timings!.maghrib ?? "null",
                            icon: Image.asset(
                              "icons/timesalah.png",
                              height: 30,
                            ),
                          ),
                          _SalahCard(
                            label: prayerTimings[4],
                            time: data.timings!.isha ?? "null",
                            icon: Image.asset(
                              "icons/timesalah.png",
                              height: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _SalahCard(
                            label: prayerTimings[5],
                            time: data.timings!.imsak ?? "null",
                            icon: Image.asset(
                              "icons/fasting.png",
                              height: 25,
                            ),
                          ),
                          _SalahCard(
                            label: prayerTimings[6],
                            time: data.timings!.lastthird ?? "null",
                            icon: Image.asset(
                              "icons/praying.png",
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final bool ignoring;
  const _TopHeader({
    Key? key,
    this.onTap,
    required this.title,
    required this.ignoring,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var todayHijry = HijriCalendar.now();

    final formattedDate = DateFormat(
      'd MMMM y',
    ).format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              size: 45,
            ),
            const SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todayHijry.toFormat("MMMM dd yyyy"),
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  "${LocaleKeys.today.tr()}/$formattedDate",
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            )
          ],
        ),

        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            IgnorePointer(
              ignoring: ignoring,
              child: SizedBox(
                height: 45,
                child: FloatingActionButton(
                  elevation: 2,
                  onPressed: onTap,
                  backgroundColor: Colors.blueGrey.shade100,
                  foregroundColor: Colors.blueGrey.shade800,
                  shape: const CircleBorder(),
                  child: ignoring
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.location_on,
                          color: Colors.blue.shade700,
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            ignoring
                ? const SizedBox()
                : Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
          ],
        ),

        // _CountrySelectionButton(
        //   ignoring: value.isLoading,
        //   title: data!.meta?.timezone ?? "null",
        //   onTap: () {
        //     value.isLoading = !value.isLoading;
        //     value.fetchAndCacheData();
        //   },
        // ),
      ],
    );
  }
}

class _SalahCard extends StatelessWidget {
  final String label;
  final String time;
  final Widget icon;

  const _SalahCard({
    Key? key,
    required this.label,
    required this.time,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
        left: 16.0,
        right: 16.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 / 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey.shade700),
                ),
                icon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SunriseCard extends StatelessWidget {
  final String sunrise;
  final String sunset;
  const _SunriseCard({
    Key? key,
    required this.sunrise,
    required this.sunset,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          sunrise,
          style: const TextStyle(fontSize: 16),
        ),
        Image.asset(
          "icons/sunrise.png",
          height: 40,
        ),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          "icons/sunset.png",
          height: 40,
        ),
        Text(
          sunset,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}



// class _CountrySelectionButton extends StatefulWidget {
//   final Map<String, String> timeZones;
//   final String selectedLocation;
//   final ValueChanged<String> onChanged;

//   const _CountrySelectionButton({
//     required this.timeZones,
//     required this.selectedLocation,
//     required this.onChanged,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CountrySelectionButtonState createState() => _CountrySelectionButtonState();
// }

// class _CountrySelectionButtonState extends State<_CountrySelectionButton> {
//   late TextEditingvalue _searchvalue;
//   late List<String> filteredLocations;

//   @override
//   void initState() {
//     super.initState();
//     _searchvalue = TextEditingvalue();
//     filteredLocations = widget.timeZones.values.toList();
//   }

//   @override
//   void dispose() {
//     _searchvalue.dispose();
//     super.dispose();
//   }

//   void _filterLocations(String query) {
//     setState(() {
//       filteredLocations = widget.timeZones.values
//           .where((location) =>
//               location.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           value: _searchvalue,
//           onChanged: _filterLocations,
//           decoration: const InputDecoration(
//             labelText: 'Поиск',
//             hintText: 'Введите название локации',
//             prefixIcon: Icon(Icons.search),
//           ),
//         ),
//         DropdownButton<String>(
//           value: widget.selectedLocation,
//           onChanged: (String? newValue) {
//             if (newValue != null) {
//               widget.onChanged(newValue);
//             }
//           },
//           items:
//               filteredLocations.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// class GregorianCalendar extends StatefulWidget {
//   const GregorianCalendar({Key? key}) : super(key: key);

//   @override
//   _GregorianCalendarState createState() => _GregorianCalendarState();
// }

// class _GregorianCalendarState extends State<GregorianCalendar> {
//   CalendarFormat format = CalendarFormat.month;
//   DateTime selectedDay = DateTime.now();
//   DateTime focusedDay = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF3EEE2),

//       body: Container(
//         decoration: mainScreenGradient,
//         child: TableCalendar(
//           calendarStyle: const CalendarStyle(
//               todayDecoration: BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.blueAccent),
//               isTodayHighlighted: true,
//               selectedDecoration:
//                   BoxDecoration(shape: BoxShape.circle, color: Colors.green),
//               selectedTextStyle: TextStyle(color: Colors.white)),
//           daysOfWeekVisible: true,
//           onDaySelected: (DateTime selecteDay, DateTime focuseDay) {
//             setState(() {
//               selectedDay = selecteDay;
//               focusedDay = focuseDay;
//             });
//           },
//           selectedDayPredicate: (DateTime date) {
//             return isSameDay(selectedDay, date);
//           },
//           startingDayOfWeek: StartingDayOfWeek.monday,
//           calendarFormat: format,
//           focusedDay: selectedDay,
//           firstDay: DateTime(1988),
//           lastDay: DateTime(2050),
//           onFormatChanged: (CalendarFormat _format) {
//             setState(() {
//               format = _format;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }



// class PrayerTimeScreen extends StatefulWidget {
//   const PrayerTimeScreen({Key? key}) : super(key: key);

//   @override
//   _PrayerTimeScreenState createState() => _PrayerTimeScreenState();
// }

// class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
//   Future<PrayerTimes>? _prayerTimesFuture;
//   late String _selectedLocation;
//    DateTime currebtDateTime = DateTime.now();
//   // Список всех доступных часовых поясов и городов
//   Map<String, String> timeZones = {};

//   @override
//   void initState() {
//     super.initState();
//     _selectedLocation = 'Asia/Bishkek';
//     _prayerTimesFuture = _getUserPrayerTimes(_selectedLocation, currebtDateTime);
//     tzdata.initializeTimeZones();
//     _getTimeZoneList();
//   }

//   void _getTimeZoneList() {
//     final locations = tz.timeZoneDatabase.locations;
//     for (var location in locations.values) {
//       timeZones[location.name] = location.name;
//     }
//   }

//   Future<PrayerTimes> _getUserPrayerTimes(String locationName,  DateTime currebtDateTime ) async {
//     try {
//       Position position = await _determinePosition();

//       double latitude = position.latitude;
//       double longitude = position.longitude;

//       Coordinates coordinates = Coordinates(latitude, longitude);

//       PrayerCalculationParameters params =
//           PrayerCalculationMethod.muslimWorldLeague();
//       params.madhab = PrayerMadhab.hanafi;

//       return PrayerTimes(
//         coordinates: coordinates,
//         calculationParameters: params,
//         precision: true,
//         locationName: locationName,
//         dateTime: DateTime.now(),
//       );
//     } catch (e) {
//       throw 'Ошибка получения местоположения: $e';
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw 'Службы местоположения отключены.';
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw 'Разрешения на местоположение отклонены.';
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw 'Разрешения на местоположение отклонены навсегда.';
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Center(
//         child: FutureBuilder<PrayerTimes>(
//           future: _prayerTimesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return SelectableText('Ошибка: ${snapshot.error}');
//             } else if (snapshot.hasData) {
//               PrayerTimes prayerTimes = snapshot.data!;
//               print("Fajr Time ${prayerTimes.coordinates.latitude}");
//               print("Fajr Time ${prayerTimes.coordinates.longitude}");
           
//               String formatPrayerTime(DateTime? time) {
//                 return DateFormat.Hm().format(time!);
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: DropdownButton<String>(
//                       icon: const Icon(Icons.location_on),
//                       value: _selectedLocation,
//                       // hint: const Text('Выберите часовой пояс'),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedLocation = newValue!;
//                           _prayerTimesFuture = _getUserPrayerTimes(newValue, currebtDateTime);
//                         });
//                       },
//                       items: timeZones.values
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(value),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _SalahCard(
//                     label: LocaleKeys.fajr.tr(),
//                     time: formatPrayerTime(prayerTimes.fajrEndTime),
//                     icon: Image.asset(
//                       "icons/timesalah.png",
//                       height: 30,
//                     ),
//                   ),
//                   _SalahCard(
//                     label: LocaleKeys.duhr.tr(),
//                     time: formatPrayerTime(prayerTimes.dhuhrStartTime),
//                     icon: Image.asset(
//                       "icons/timesalah.png",
//                       height: 30,
//                     ),
//                   ),
//                   _SalahCard(
//                     label: LocaleKeys.asr.tr(),
//                     time: formatPrayerTime(prayerTimes.asrStartTime),
//                     icon: Image.asset(
//                       "icons/timesalah.png",
//                       height: 30,
//                     ),
//                   ),
//                   _SalahCard(
//                     label: LocaleKeys.maghrib.tr(),
//                     time: formatPrayerTime(prayerTimes.maghribStartTime),
//                     icon: Image.asset(
//                       "icons/timesalah.png",
//                       height: 30,
//                     ),
//                   ),
//                   _SalahCard(
//                     label: LocaleKeys.isha.tr(),
//                     time: formatPrayerTime(prayerTimes.ishaStartTime),
//                     icon: Image.asset(
//                       "icons/timesalah.png",
//                       height: 30,
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Text('Нет данных');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
