import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/screens/booksScreen/books_ditails.dart';
import 'package:avrod/screens/booksScreen/pdf_api_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';

import 'list_of_all_books.dart';

class SelectedBooks extends StatelessWidget {
  const SelectedBooks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: iconColor,
            )),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: mainScreenGradient,
        ),
        title: Text('Книги',
            style: TextStyle(fontSize: 18.sp, color: titleAbbBar)),
        centerTitle: true,
      ),
      body: Container(
        decoration: mainScreenGradient,
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: booksRu.name!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: ScaleAnimation(
                  child: InkWell(
                    onTap: () async {
                      final file =
                          await PDFApi.loadNetwork(booksRu.path![index]);
                      openPDF(context, file);
                    },
                    child: ListTile(

                        // ignore: avoid_unnecessary_containers
                        title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: CachedNetworkImage(
                            imageUrl: booksRu.urlImage![index],
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0)),
                                ),
                                height: 12.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      booksRu.name![index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
