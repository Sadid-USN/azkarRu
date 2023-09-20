import 'package:avrod/controllers/data_uploader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataUploadedScreen extends StatelessWidget {
  const DataUploadedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureProvider<void>(
          create: (context) {
            final controller = Provider.of<DataUploaderController>(context);
            return controller.uploadData(context);
          },
          initialData: null, // You can provide an initial value here if needed
          child: Consumer<DataUploaderController>(
            builder: (context, controller, child) {
              if (controller.loadingStatus == LoadingStatus.completed) {
                return const Text('Uploading Completed');
              } else {
                return const Text('Uploading...');
              }
            },
          ),
        ),
      ),
    );
  }
}
