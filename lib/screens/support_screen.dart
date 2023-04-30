import 'package:animate_icons/animate_icons.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({
    Key? key,
  }) : super(key: key);
  static String routNaem = '/supportScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 177, 150),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        backgroundColor: const Color.fromARGB(255, 201, 177, 150),
        title:  Text(
          'support'.tr(),
          style:  TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2 * 0.6,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listCard.length,
                    itemBuilder: (context, index) {
                      return SupportCard(
                        initials: listCard[index].initials,
                        cardNumbers: listCard[index].cardNumbers,
                        icon: listCard[index].icon,
                        gradient: listCard[index].gradient,
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text:
                      'Ваша поддержка помогает нам улучшить и расширить приложение. Мы ценим любую форму поддержки, которая способствует оживлению сунны пророка (ﷺ). Будь то финансовая помощь, или распространение информации о нашем приложении, мы признательны за любую помощь. Сказал Всевышний Аллах в Своей священной книге: \n',
                  style: GoogleFonts.ptSerif(
                      color: const Color.fromARGB(255, 75, 65, 65),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text:
                      '«Стремитесь к прощению вашего Господа и Раю, ширина которого равна небесам и земле, уготованному для богобоязненных, которые делают пожертвования в радости и в горе, сдерживают гнев и прощают людей. Воистину, Аллах любит творящих добро.».\n',
                  style: GoogleFonts.ptSerif(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      '(Оли Имрон 133)\n От Абухурайры передается, что Пророк Аллах (ﷺ) сказал:\n',
                  style: GoogleFonts.ptSerif(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text:
                      '«Когда человек умирает, (все) его дела прекращаются (прекращает получать награду) за исключением трёх: непрерывной милостыни, знания, которым могут пользоваться (другие люди), или праведного ребёнка, который станет обращаться к Аллаху с мольбами за него”». Этот хадис передал Муслим (1631).\n',
                  style: GoogleFonts.ptSerif(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'С дозволения Всевышнего мы будем продолжать работать над улучшением приложения. Вся хвала Всевышнему Аллаху, Господу миров!',
                  style: GoogleFonts.ptSerif(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ])),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String cardNumbers;
  final String icon;
  final String initials;
  final LinearGradient? gradient;
  SupportCard({
    Key? key,
    required this.cardNumbers,
    required this.icon,
    required this.initials,
    this.gradient,
  }) : super(key: key);

  AnimateIconController animateIconController = AnimateIconController();
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        width: MediaQuery.of(context).size.width / 2 * 1.9,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: const DecorationImage(
              opacity: 0.4,
              image: AssetImage('icons/iconavrod.png'),
              fit: BoxFit.cover),
          gradient: gradient,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0)
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              right: 0.0,
              child: AvatarGlow(
                endRadius: 30.0,
                child: Material(
                  // Replace this child with your own
                  elevation: 8.0,
                  shape: CircleBorder(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10),
                  child: Image.asset(
                    icon,
                    height: 35,
                    width: 35,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectableText(
                      cardNumbers,
                      //
                      style: GoogleFonts.ptSerif(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    AnimateIcons(
                      startIcon: Icons.copy,
                      endIcon: Icons.check_circle_outline,
                      controller: animateIconController,
                      size: 25.0,
                      onStartIconPress: () {
                        FlutterClipboard.copy(
                          cardNumbers,
                        );

                        return true;
                      },
                      onEndIconPress: () {
                        return true;
                      },
                      duration: const Duration(milliseconds: 250),
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      clockwise: false,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        '/Avrod',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //! BACK
      back: Container(
        width: MediaQuery.of(context).size.width / 2 * 1.9,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: const DecorationImage(
              opacity: 0.3,
              image: AssetImage('icons/iconavrod.png'),
              fit: BoxFit.cover),
          gradient: gradient,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ٱلَّذِینَ یَذۡكُرُونَ ٱللَّهَ قِیَـٰمࣰا وَقُعُودࣰا وَعَلَىٰ جُنُوبِهِمۡ وَیَتَفَكَّرُونَ فِی خَلۡقِ ٱلسَّمَـٰوَ ٰ⁠تِ وَٱلۡأَرۡضِ رَبَّنَا مَا خَلَقۡتَ هَـٰذَا بَـٰطِلࣰا سُبۡحَـٰنَكَ فَقِنَا عَذَابَ ٱلنَّارِ',
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Avrod',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<SupportCard> listCard = [
  SupportCard(
    cardNumbers: '4177   4901   6419   2280',
    initials: 'Natynkul Zhyrgalbekova',
    icon: 'assets/support/mbank.png',
    gradient: LinearGradient(
      colors: [
        Colors.indigo.shade600,
        Colors.blue.shade300,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  SupportCard(
    cardNumbers: "4177   4901   6183   8117",
    initials: 'Natynkul Zhyrgalbekova',
    icon: 'assets/support/mbank.png',
    gradient: LinearGradient(colors: [
      Colors.blue.shade900,
      Colors.cyan.shade600,
    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
  ),
  
  SupportCard(
    cardNumbers: '4274   3200   7851   2616',
    initials: 'Sadid Idibekov',
    icon: 'assets/support/icon_sber.png',
    gradient: LinearGradient(
      colors: [
        Colors.blue.shade900,
        Colors.blue,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];
