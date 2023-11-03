import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/core/db_helper.dart';
import 'package:avrod/core/glowing_progress.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/main.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:avrod/models/book_model.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'package:sizer/sizer.dart';



class ChapterScreen extends StatefulWidget {
  const ChapterScreen({
    Key? key,
    this.bookIndex,
    this.title,
  }) : super(key: key);
  final int? bookIndex;
  final String? title;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Box? likesBox;
  bool isSearchBarVisible = false;
  List<Chapters> _filteredChapters = [];
  String _searchQuery = "";
  final likeDBHelper = LikeDBHelper();


  @override
  void initState() {
    initHive();
    super.initState();
  }

  void initHive() async {
    likesBox = await Hive.openBox(FAVORITES_BOX);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF9E2C5),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: iconColor,
          ),
        ),
        elevation: 3.0,
        title: SelectableText(
          widget.title!,
          style: GoogleFonts.ptSerif(
            fontSize: 14.sp,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BookModel>>(
        future: BookFunctions.getBookLocally(context),
        builder: (context, snapshot) {
          final books = snapshot.data;
          if (snapshot.hasData) {
            final book = books![widget.bookIndex!];
            _filteredChapters = book.chapters ?? [];

            if (_searchQuery.isNotEmpty) {
              _filteredChapters = _filteredChapters.where((chapter) {
                return chapter.name!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();
            }

            return Container(
              decoration: mainScreenGradient,
              child: Column(
                children: [
                  _SearchBar(
                    onSearchTextChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                  Expanded(
                    child: buildBook(_filteredChapters),
                  ),
                ],
              ),
            );
          }
          return const GlowingProgress();
        },
      ),
    );
  }

  Widget buildBook(List<Chapters> chapters) {
    return AnimationLimiter(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            color: dividerColor,
          );
        },
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 5, bottom: 25),
        physics: const BouncingScrollPhysics(),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: chapter.listimage!.length,
            child: ScaleAnimation(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: () {
                 
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TextScreen(
                        texts: chapter.texts,
                        chapter: chapter,
                        index: index,
                      );
                    }));
                  },
                  trailing: CircleAvatar(
                    backgroundColor: const  Color(0xffF9E2C5),
                    child: LikeButton(
                      likeBuilder: (isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? Colors.red : Colors.grey,
                        );
                      },
                      isLiked: isChapterLiked(chapter.id!),
                      onTap: (isLiked) async {
                        return saveLike(chapter.id ?? 0, isLiked);
                      },
                      size: 20.sp,
                      circleColor: const CircleColor(
                        start: Color(0xffFF0000),
                        end: Color(0xffFF0000),
                      ),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xffffffff),
                        dotSecondaryColor: Color(0xffBF40BF),
                      ),
                    ),
                  ),
                  leading: Text(
                    "${chapter.id! + 1}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ptSerif(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  title: Text(
                    chapter.name ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.ptSerif(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> saveLike(int chapterID, bool isLiked) async {
    if (!isLiked) {
      await likesBox!.put(chapterID, (false).toString());
    } else {
      await likesBox!.delete(chapterID);
    }

    return !isLiked;
  }

  bool isChapterLiked(int chapterID) {
    bool isLiked = likesBox!.containsKey(chapterID);
    return isLiked;
  }
}

class _SearchBar extends StatefulWidget {
  final void Function(String query) onSearchTextChanged;

  const _SearchBar({Key? key, required this.onSearchTextChanged})
      : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  void _searchItems() {
    final query = _searchController.text;
    widget.onSearchTextChanged(query);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchItems);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: GoogleFonts.alice(fontSize: 18, fontWeight: FontWeight.normal),
        controller: _searchController,
        cursorHeight: 25,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: LocaleKeys.search.tr(),
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.search, color: Colors.blueGrey.shade600)),
      ),
    );
  }
}

class LocalKeys {}
