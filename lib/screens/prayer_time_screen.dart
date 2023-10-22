import 'package:avrod/colors/colors.dart';
import 'package:avrod/core/extention_capitalize.dart';
import 'package:avrod/core/notify_helper.dart';
import 'package:avrod/core/try_again_button.dart';
import 'package:avrod/data/counties_and_capitals.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:avrod/API/prayers_api.dart';

import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/prayers_model.dart';
import 'package:just_audio/just_audio.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({Key? key}) : super(key: key);

  @override
  _PrayerTimeScreenState createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  Future<PrayersModel>? _prayerModel;
  // String city = "Bishkek";
  String country = "North Korea";
  String capital = "Pyongyang";
  DateTime dateForfam = DateTime.now();
  final prayStorage = GetStorage();
  final countryStorage = GetStorage();
  final capitalStorage = GetStorage();
  final player = AudioPlayer();
  int notificationId = 0;
  bool isSoundEnabled = true;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();

    _loadSavedCountry();
    _fetchAndCacheData();
    _notificationHelper.initNotification();
  }

  Future<void> _fetchAndCacheData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final cachedData = prayStorage.read('prayer_data');

    if (cachedData != null) {
      setState(() {
        _prayerModel = Future.value(PrayersModel.fromJson(cachedData));
      });
    }

    if (context.mounted) {
      final PrayersModel newData = await PrayersApi().getData(
          context: context,
          capital: capital,
          country: country,
          date: DateFormat('dd-MM-yyyy').format(dateForfam));
      prayStorage.write('prayer_data', newData.toJson());

      setState(() {
        _prayerModel = Future.value(newData);
      });
      final Timings prayerTimings = newData.data!.timings!;

      _schedulePrayerNotifications(
        prayerTimings,
        DateFormat('dd-MM-yyyy').format(dateForfam),
      );
    }
  }

  Future<void> _schedulePrayerNotifications(
      Timings prayerTimings, String currentDate) async {
    if (currentDate != DateFormat('dd-MM-yyyy').format(dateForfam)) {
      // Если данные о времени молитвы не актуальны для текущей даты, перезагрузагружаем
      final PrayersModel newData = await PrayersApi().getData(
          context: context,
          capital: capital,
          country: country,
          date: formattedDate);
      prayStorage.write('prayer_data', newData.toJson());
      prayerTimings = newData.data!.timings!;
    }

    final Map<String, String> timingsMap = {
      LocaleKeys.fajr.tr().capitalize(): prayerTimings.fajr ?? "_",
      LocaleKeys.duhr.tr().capitalize(): prayerTimings.dhuhr  ?? "_",
      LocaleKeys.asr.tr().capitalize():  prayerTimings.asr ?? "_",
      LocaleKeys.maghrib.tr().capitalize(): prayerTimings.maghrib ?? "_",
      LocaleKeys.isha.tr().capitalize(): prayerTimings.isha ?? "_",
    };

    for (var prayerName in timingsMap.keys) {
      final prayerTime = timingsMap[prayerName]!.split(':');
      final hour = int.parse(prayerTime[0]);
      final minutes = int.parse(prayerTime[1]);

      _notificationHelper.scheduleNotification(
        isSoundEnabled: isSoundEnabled,
        id: notificationId++,
        hour: hour,
        minutes: minutes,
        parayName: prayerName,
        body:
            '${LocaleKeys.itsTimeFor.tr().capitalize()} ${prayerName.capitalize()}',
      );
    }
  }

  // Function to show the country picker
  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: LocaleKeys.search.tr(),
          hintText: LocaleKeys.startSearch.tr(),
          labelStyle: const TextStyle(fontSize: 14),
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 0.5,
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country selectedCountry) {
        setState(() {
          country = selectedCountry.name;

          capital = countriesAndCapitals[country] ?? 'Pyongyang';
        });

        final storage = GetStorage();

        storage.write('country', country);
        capitalStorage.write('capital', capital);

        _fetchAndCacheData();
      },
    );
  }

  Future<void> _loadSavedCountry() async {
    // final savedCity = storage.read('city');
    final savedCountry = countryStorage.read('country');
    final savedCapital = capitalStorage.read('capital');

    if (savedCountry != null) {
      setState(() {
        country = savedCountry;
        capital = savedCapital;

        print(country);
      });
    } else {
      setState(() {
        country;
      });
    }
  }

  var todayHijry = HijriCalendar.now();

  final formattedDate = DateFormat(
    'd MMMM y',
  ).format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder<PrayersModel>(
        future: _prayerModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: TryAgainButton(onPressed: () {
                _fetchAndCacheData();
              }),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!.data;

            final prayerTimings = [
              LocaleKeys.fajr.tr(),
              LocaleKeys.duhr.tr(),
              LocaleKeys.asr.tr(),
              LocaleKeys.maghrib.tr(),
              LocaleKeys.isha.tr(),
              LocaleKeys.fast.tr(),
              LocaleKeys.Lastthird.tr()
            ];

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 25),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 40,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${LocaleKeys.today.tr()}/$formattedDate"),
                                Text(todayHijry.toFormat(
                                  "MMMM dd yyyy",
                                )),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),

                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       isSoundEnabled = !isSoundEnabled;
                            //     });
                            //   },
                            //   child: Image.asset(
                            //     isSoundEnabled
                            //         ? "icons/volume.png"
                            //         : "icons/volumeOff.png",
                            //     height: 30,
                            //   ),
                            // ),
                          ],
                        ),
                        _CountrySelectionButton(
                          title: country.isEmpty || country == "North Korea"
                              ? LocaleKeys.chooseYourCountry.tr()
                              : country,
                          onTap: () {
                            _showCountryPicker();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _SunriseCard(
                          sunrise: data?.timings?.sunrise ?? "null",
                          sunset: data?.timings?.sunset ?? "null",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _SalahCard(
                          label: prayerTimings[0],
                          time: data?.timings!.fajr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          label: prayerTimings[1],
                          time: data?.timings!.dhuhr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          label: prayerTimings[2],
                          time: data?.timings!.asr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          label: prayerTimings[3],
                          time: data?.timings!.maghrib ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          label: prayerTimings[4],
                          time: data?.timings!.isha ?? "null",
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
                          time: data?.timings!.imsak ?? "null",
                          icon: Image.asset(
                            "icons/fasting.png",
                            height: 25,
                          ),
                        ),
                        _SalahCard(
                          label: prayerTimings[6],
                          time: data?.timings!.lastthird ?? "null",
                          icon: Image.asset(
                            "icons/praying.png",
                            height: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _CountrySelectionButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const _CountrySelectionButton({
    Key? key,
    this.onTap,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF8E4CF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Colors.blueGrey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            const Spacer(),
            Icon(
              Icons.location_on,
              color: Colors.blue.shade700,
            ),
            const Spacer(
              flex: 3,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(
              flex: 3,
            ),
            const SizedBox(
              width: 14,
            ),
            Icon(Icons.arrow_drop_down, color: Colors.blueGrey.shade800),
            const Spacer(),
          ],
        ),
      ),
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
      margin: const EdgeInsets.only(bottom: 8),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 / 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 16),
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
        Text(sunrise),
        Image.asset(
          "icons/sunrise.png",
          height: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          "icons/sunset.png",
          height: 30,
        ),
        Text(sunset),
      ],
    );
  }
}

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
