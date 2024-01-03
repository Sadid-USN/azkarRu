import 'package:avrod/API/prayers_api.dart';
import 'package:avrod/data/counties_and_capitals.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/prayers_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PrayTimeController extends ChangeNotifier {
  String country = "North Korea";
  String capital = "Pyongyang";
  Future<PrayersModel>? prayerModel;
  DateTime dateForfam = DateTime.now();
  final prayStorage = GetStorage();
  final countryStorage = GetStorage();
  final capitalStorage = GetStorage();
  bool isLoading = false;

   PrayTimeController() {
  
    _initialize();
  }

  Future<void> _initialize() async {

    await fetchAndCacheData();
  }

 Future<void> fetchAndCacheData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (isLoading) return; // Prevent recursive calls
    isLoading = true;
    notifyListeners();
    try {
      final position = await determinePosition();
      final newData = await PrayersApi().getPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
        date: DateFormat('dd-MM-yyyy').format(dateForfam),
      );

      prayStorage.write('prayer_data', newData.toJson());

      prayerModel = Future.value(newData);
    } catch (e) {
      prayerModel = Future.error(LocaleKeys.locationErrorTexr.tr());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateCountry(String selectedCountry) {
    country = selectedCountry;
    capital = countriesAndCapitals[country] ?? 'Pyongyang';
    fetchAndCacheData();
  }
  void onShowCountryPicker(BuildContext context) {
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
        updateCountry(selectedCountry.name);
      },
    );
  }
}
