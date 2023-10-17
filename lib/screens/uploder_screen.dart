import 'package:avrod/controllers/data_uploader.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DataUploadedScreen extends StatelessWidget {
  const DataUploadedScreen({Key? key}) : super(key: key);


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider<DataUploaderController>(
          create: (context) => DataUploaderController(context),
          child: Consumer<DataUploaderController>(
            builder: (context, controller, child) {
              if (controller.loadingStatus == LoadingStatus.completed) {
                return const Text('Uploading Completed');
              } else if (controller.loadingStatus == LoadingStatus.loading) {
                return const Text('Uploading...');
              } else {
                return const Text('Error Uploading');
              }
            },
          ),
        ),
      ),
    );
  }
}
