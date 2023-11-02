import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/book_functions.dart';
import '../data/book_model.dart';
import '../core/glowing_progress.dart';
import 'home_page.dart';
class OnBoardingScreen extends StatelessWidget {
 const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Book>>(
          create: (_) => BookFunctions.getBookLocally(context),
          initialData: const [],
          child: Consumer<List<Book>>(
            builder: (context, bookList, _) {
              return  bookList.isEmpty
                    ? const GlowingProgress()
                    : const HomePage();
            },
          ),
        );
  }
}