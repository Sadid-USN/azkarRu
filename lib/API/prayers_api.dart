import 'dart:async';
import 'dart:convert';

import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/prayers_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrayersApi {
  Future<PrayersModel> getData(
      {required BuildContext context, required String country}) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.aladhan.com/v1/timingsByCity/03-10-2023?city=$country&country=$country&method=8"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prayersModel = PrayersModel.fromJson(data);

        return prayersModel;
      } else {
        // Show a Snackbar for failed network request

        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      if (context.mounted) {
        showNetworkSnackbar(context, LocaleKeys.checkConnection.tr());
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
