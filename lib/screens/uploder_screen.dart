import 'package:avrod/controllers/data_uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:csv/csv.dart';

import 'dart:async' show Future;
import 'package:provider/provider.dart';

import '../main.dart';

class DataUploadedScreen extends StatefulWidget {
  const DataUploadedScreen({Key? key}) : super(key: key);

  @override
  State<DataUploadedScreen> createState() => _DataUploadedScreenState();
}

class _DataUploadedScreenState extends State<DataUploadedScreen> {
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider<DataUploaderController>(
          create: (context) => DataUploaderController(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<DataUploaderController>(
                builder: (context, controller, child) => ElevatedButton(
                  onPressed: () {
                    if (controller.loadingStatus == LoadingStatus.completed) {
                      controller.setMessage(
                          context, "Data successfully uploaded to Firebase");
                    } else if (controller.loadingStatus ==
                        LoadingStatus.loading) {
                      controller.setMessage(context, "Uploading....");
                    } else {
                      controller.setMessage(context, "Error Uploading");
                    }
                  },
                  child: const Text(
                      "Upload Json to Firebase"), // No need for const here
                ),
              ),

              // Consumer<DataUploaderController>(
              //   builder: (context, controller, child) {
              //     if (controller.loadingStatus == LoadingStatus.completed) {
              //       return const Text('Uploading Completed');
              //     } else if (controller.loadingStatus ==
              //         LoadingStatus.loading) {
              //       return const Text('Uploading...');
              //     } else {
              //       return const Text('Error Uploading');
              //     }
              //   },
              // ),
              const SizedBox(
                height: 50,
              ),
              // IgnorePointer(
              //   ignoring: isUploading,
              //   child: ElevatedButton(
              //     onPressed: isUploading ? null : _handleExportData,
              //     child: isUploading
              //         ? const Center(
              //             child: SizedBox(
              //                 width: 50, child: CircularProgressIndicator()))
              //         : const Text('Export CSV to Firebase'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // void exportData() async {
  //   final CollectionReference book =
  //       FirebaseFirestore.instance.collection("books");
  //   final myData = await rootBundle.loadString("assets/DB/molba.csv");
  //   List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
  //   List<List<dynamic>> data = [];
  //   data = csvTable;

  //   for (var i = 0; i < data.length; i++) {
  //     var record = {"molba": data[i][0]};
  //     book.add(record);
  //   }
  // }

  Future<void> _handleExportData() async {
    setState(() {
      isUploading = true;
    });

    try {
      final CollectionReference book =
          FirebaseFirestore.instance.collection("molba");
      final myData = await rootBundle.loadString("assets/DB/molba.csv");
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
      List<List<dynamic>> data = [];
      data = csvTable;

      for (var i = 0; i < data.length; i++) {
        var record = {
          "molba": data[i][0],
          "id": data[i][1],
          "author": data[i][2],
          "title": data[i][3],
          "image": data[i][4],
        };
        await book.add(record);
      }

      // Data upload successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data successfully uploaded to Firebase'),
        ),
      );
    } catch (error) {
      // Handle the error, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading data to Firebase: $error'),
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> readFromGsheet() async {
    final CollectionReference book =
        FirebaseFirestore.instance.collection("molba");
    final gsheets = GSheets(credentials);
    final spreadsheet = await gsheets.spreadsheet(ssId);
    var sheet = spreadsheet.worksheetByTitle("molba");
    int rows = sheet!.rowCount;
    List<Cell?> sellsRow;
    for (var i = 0; i < rows; i++) {
      sellsRow = await sheet.cells.row(i);
      print(sellsRow.elementAt(1)!.value);
    }
  }
}
