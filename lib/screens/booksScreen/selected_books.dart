import 'package:avrod/core/addbunner.dart';
import 'package:avrod/screens/booksScreen/books_ditails.dart';
import 'package:avrod/screens/booksScreen/pdf_api_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import 'list_of_all_books.dart';

class SelectedBooks extends StatefulWidget {
  const SelectedBooks({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedBooks> createState() => _SelectedBooksState();
}

class _SelectedBooksState extends State<SelectedBooks> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3EEE2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // bannerAdHelper.isBannerAd
            //     ? SizedBox(
            //         height: bannerAdHelper.bannerAd.size.height.toDouble(),
            //         width: bannerAdHelper.bannerAd.size.width.toDouble(),
            //         child: AdWidget(ad: bannerAdHelper.bannerAd),
            //       )
            //     : const SizedBox(),
            AnimationLimiter(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 2.2,
                      mainAxisExtent: MediaQuery.of(context).size.height / 7),
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
                            if (context.mounted) {
                              openPDF(context, file);
                            }
                          },
                          child: ListTile(
                            // ignore: avoid_unnecessary_containers
                            title: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://i.pinimg.com/originals/f3/7d/c5/f37dc5e4ea716ad61962daf36a070c0d.jpg',
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        height: 12.h,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text(
                                              booksRu.name![index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 10,
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
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
