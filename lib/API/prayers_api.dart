import 'dart:async';
import 'dart:convert';
import 'package:avrod/models/prayers_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class PrayersApi {
  Future<PrayersModel> getPrayerTimes(
      {required BuildContext context,
      required String country,
      required String capital,
      required String date}) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.aladhan.com/v1/timingsByCity/$date?city=$capital&country=$country&method=8"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prayersModel = PrayersModel.fromJson(data);
        print(capital);
        return prayersModel;
      } else {
        // Show a Snackbar for failed network request

        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      if (context.mounted) {
        //  showNetworkSnackbar(context, LocaleKeys.checkConnection.tr());
      }

      throw "Error";
    }
  }

  void showNetworkSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}