import 'package:adhan_dart/adhan_dart.dart';

class CoordinatesInit {
  void initCoordinates() {
    Coordinates coordinates = Coordinates(42.8746, 74.5698);
    DateTime date = DateTime.now();
    CalculationParameters calculationParameters =
        CalculationMethod.MuslimWorldLeague();
    PrayerTimes prayerTimes =
        PrayerTimes(coordinates, date, calculationParameters, precision: true);

    DateTime fajrTime = prayerTimes.fajr!.toLocal();
    print("THIS IS FAJR TIME ---> $fajrTime");
    double degree = Qibla.qibla(coordinates);
    print("Qibla's Degree is ---> $degree");
  }
}
