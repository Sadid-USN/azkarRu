import 'package:avrod/core/glowing_progress.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




import 'home_page.dart';
class OnBoardingScreen extends StatelessWidget {
 const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<BookModel>>(
          create: (_) => BookFunctions.getBookLocally(context),
          initialData: const [],
          child: Consumer<List<BookModel>>(
            builder: (context, bookList, _) {
              return  bookList.isEmpty
                    ? const GlowingProgress()
                    : const HomePage();
            },
          ),
        );
  }
}