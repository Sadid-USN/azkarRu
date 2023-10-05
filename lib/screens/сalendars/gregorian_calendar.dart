import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hijri/hijri_calendar.dart';

import 'package:avrod/API/prayers_api.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/prayers_model.dart';

class GregorianCalendar extends StatefulWidget {
  const GregorianCalendar({Key? key}) : super(key: key);

  @override
  _GregorianCalendarState createState() => _GregorianCalendarState();
}

class _GregorianCalendarState extends State<GregorianCalendar> {
  Future<PrayersModel>? _futureData;
  // String city = "Bishkek";
  String country = "Kyrgyzstan";
  DateTime dateForfam = DateTime.now();
  //BannerAdHelper bannerAdHelper = BannerAdHelper();

  @override
  void initState() {
    super.initState();

    _fetchData();
    _loadSavedCountry();

    // bannerAdHelper.initializeAdMob(
    //   onAdLoaded: (ad) {
    //     setState(() {
    //       bannerAdHelper.isBannerAd = true;
    //     });
    //   },
    // );

    // Start fetching data when the widget is initialized
  }

  // @override
  // void dispose() {
  //   bannerAdHelper.bannerAd.dispose();
  //   super.dispose();
  // }

  Future<void> _fetchData() async {
    setState(() {
      _futureData = PrayersApi().getData(context: context, country: country);

      print(country);
    });
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
        });
        _fetchData();

        final storage = GetStorage();

        storage.write('country', country);
      },
    );
  }

  Future<void> _loadSavedCountry() async {
    final storage = GetStorage();
    // final savedCity = storage.read('city');
    final savedCountry = storage.read('country');

    if (savedCountry != null) {
      setState(() {
        // city = savedCity;
        country = savedCountry;

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
      backgroundColor: const Color(0xffF3EEE2),
      body: FutureBuilder<PrayersModel>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${LocaleKeys.checkConnection.tr()} ${snapshot.error}'),
                TextButton(
                    onPressed: () {
                      _fetchData();
                    },
                    child: Text(
                      LocaleKeys.tryAgain.tr(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          shadows: [
                            const Shadow(
                              offset: Offset(0.5, 0.4),
                              blurRadius: 1.0,
                              color: Colors.blue,
                            ),
                          ],
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ))
              ],
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
                          offset: Offset(0.0, 1.0), //(x,y)
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
                          ],
                        ),
                        _CountrySelectionButton(
                          title: country.isEmpty
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
                          lable: prayerTimings[0],
                          time: data?.timings!.fajr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        // SalahCard(
                        //   lable: "Sunrise",
                        //   time: data?.timings!.fajr ?? "null",
                        //   icon: Image.asset(
                        //       "icons/sunrise.png",
                        //       height: 30,
                        //     ),
                        // ),
                        _SalahCard(
                          lable: prayerTimings[1],
                          time: data?.timings!.dhuhr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          lable: prayerTimings[2],
                          time: data?.timings!.asr ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          lable: prayerTimings[3],
                          time: data?.timings!.maghrib ?? "null",
                          icon: Image.asset(
                            "icons/timesalah.png",
                            height: 30,
                          ),
                        ),
                        _SalahCard(
                          lable: prayerTimings[4],
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
                          lable: prayerTimings[5],
                          time: data?.timings!.imsak ?? "null",
                          icon: Image.asset(
                            "icons/fasting.png",
                            height: 25,
                          ),
                        ),
                        _SalahCard(
                          lable: prayerTimings[6],
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
            return const Center(child: Text('No Data Available'));
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: const Color(0xffF8E4CF),
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        leading: Icon(
          Icons.location_on,
          color: Colors.blueGrey.shade800,
        ),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.blueGrey.shade800),
      ),
    );
  }
}

enum Side {
  left,
  right,
}

class _SalahCard extends StatelessWidget {
  final String lable;
  final String time;
  final Widget icon;

  const _SalahCard({
    Key? key,
    required this.lable,
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
        // borderRadius: const BorderRadius.only(
        //   topRight: Radius.circular(12),
        //   bottomRight: Radius.circular(12),
        // ),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lable,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2 / 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 16),
                ),
                // const SizedBox(width: 50,),
                icon,
              ],
            ),
          )
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
