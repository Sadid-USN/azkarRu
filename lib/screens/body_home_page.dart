import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../colors/colors.dart';
import '../data/book_map.dart';
import '../data/titles.dart';
import 'chapter_screen.dart';

class BodyHomePage extends StatelessWidget {
  const BodyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    final books = Provider.of<List<Book>>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF3EEE2),
      body: ListView(
        children: [
          Column(
            children: [
              // Lottie.asset(
              //   'assets/lotties/stars.json',
              //   fit: BoxFit.cover,
              //   height: 10,
              //   width: currentWidth,
              //   repeat: true,
              //   reverse: true,
              // ),
              const SizedBox(height: 20),
              GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Set the number of columns as you want
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio:
                      1, // Adjust this value to control item aspect ratio
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a, b) {
                            return ChapterScreen(
                              bookIndex: index,
                              title: titles[index],
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          books[index].image ?? "",
                        //  width: 30.w,
                           height: 100,
                        ),
                        SelectableText(
                          books[index].name ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 8,
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
