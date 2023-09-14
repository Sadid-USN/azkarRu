// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Azkar Daily prayers`
  String get avrod {
    return Intl.message(
      'Azkar Daily prayers',
      name: 'avrod',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get lang {
    return Intl.message(
      'Languages',
      name: 'lang',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Radio Quran`
  String get radio {
    return Intl.message(
      'Radio Quran',
      name: 'radio',
      desc: '',
      args: [],
    );
  }

  /// `Beginning of the day`
  String get title1 {
    return Intl.message(
      'Beginning of the day',
      name: 'title1',
      desc: '',
      args: [],
    );
  }

  /// `Salah prayers`
  String get title2 {
    return Intl.message(
      'Salah prayers',
      name: 'title2',
      desc: '',
      args: [],
    );
  }

  /// `Morning and evening azkars`
  String get title3 {
    return Intl.message(
      'Morning and evening azkars',
      name: 'title3',
      desc: '',
      args: [],
    );
  }

  /// `Prayers before bed`
  String get title4 {
    return Intl.message(
      'Prayers before bed',
      name: 'title4',
      desc: '',
      args: [],
    );
  }

  /// `Joy and sadness`
  String get title5 {
    return Intl.message(
      'Joy and sadness',
      name: 'title5',
      desc: '',
      args: [],
    );
  }

  /// `Food and drink`
  String get title6 {
    return Intl.message(
      'Food and drink',
      name: 'title6',
      desc: '',
      args: [],
    );
  }

  /// `Hajj prayers`
  String get title7 {
    return Intl.message(
      'Hajj prayers',
      name: 'title7',
      desc: '',
      args: [],
    );
  }

  /// `Relationship`
  String get title8 {
    return Intl.message(
      'Relationship',
      name: 'title8',
      desc: '',
      args: [],
    );
  }

  /// `Nature`
  String get title9 {
    return Intl.message(
      'Nature',
      name: 'title9',
      desc: '',
      args: [],
    );
  }

  /// `Illness and death`
  String get title10 {
    return Intl.message(
      'Illness and death',
      name: 'title10',
      desc: '',
      args: [],
    );
  }

  /// `Ruqyah from Sihr (magic) and evil eye`
  String get title11 {
    return Intl.message(
      'Ruqyah from Sihr (magic) and evil eye',
      name: 'title11',
      desc: '',
      args: [],
    );
  }

  /// `Family and life`
  String get title12 {
    return Intl.message(
      'Family and life',
      name: 'title12',
      desc: '',
      args: [],
    );
  }

  /// `Ahkams of sacrifices`
  String get title13 {
    return Intl.message(
      'Ahkams of sacrifices',
      name: 'title13',
      desc: '',
      args: [],
    );
  }

  /// `Quran prayers`
  String get title14 {
    return Intl.message(
      'Quran prayers',
      name: 'title14',
      desc: '',
      args: [],
    );
  }

  /// `Share with others`
  String get share {
    return Intl.message(
      'Share with others',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Ulamuyaman@gmail.com`
  String get email {
    return Intl.message(
      'Ulamuyaman@gmail.com',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Other applications`
  String get allApps {
    return Intl.message(
      'Other applications',
      name: 'allApps',
      desc: '',
      args: [],
    );
  }

  /// `@darul_asar`
  String get instagram {
    return Intl.message(
      '@darul_asar',
      name: 'instagram',
      desc: '',
      args: [],
    );
  }

  /// `YouTube`
  String get youTube {
    return Intl.message(
      'YouTube',
      name: 'youTube',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get hintText {
    return Intl.message(
      'Search',
      name: 'hintText',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Favorite chapters`
  String get favorite {
    return Intl.message(
      'Favorite chapters',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Hijri calendar`
  String get hijri {
    return Intl.message(
      'Hijri calendar',
      name: 'hijri',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Learn more`
  String get learnMore {
    return Intl.message(
      'Learn more',
      name: 'learnMore',
      desc: '',
      args: [],
    );
  }

  /// `Translation`
  String get translation {
    return Intl.message(
      'Translation',
      name: 'translation',
      desc: '',
      args: [],
    );
  }

  /// `Healthy Heart!`
  String get titlenotifi1 {
    return Intl.message(
      'Healthy Heart!',
      name: 'titlenotifi1',
      desc: '',
      args: [],
    );
  }

  /// `Mercy`
  String get titlenotifi2 {
    return Intl.message(
      'Mercy',
      name: 'titlenotifi2',
      desc: '',
      args: [],
    );
  }

  /// `True Muslim`
  String get titlenotifi3 {
    return Intl.message(
      'True Muslim',
      name: 'titlenotifi3',
      desc: '',
      args: [],
    );
  }

  /// `Radiant Face`
  String get titlenotifi4 {
    return Intl.message(
      'Radiant Face',
      name: 'titlenotifi4',
      desc: '',
      args: [],
    );
  }

  /// `Parents!`
  String get titlenotifi5 {
    return Intl.message(
      'Parents!',
      name: 'titlenotifi5',
      desc: '',
      args: [],
    );
  }

  /// `Speak Good`
  String get titlenotifi6 {
    return Intl.message(
      'Speak Good',
      name: 'titlenotifi6',
      desc: '',
      args: [],
    );
  }

  /// `Respect for Neighbor`
  String get titlenotifi7 {
    return Intl.message(
      'Respect for Neighbor',
      name: 'titlenotifi7',
      desc: '',
      args: [],
    );
  }

  /// `Allah the Almighty said`
  String get titlenotifi8 {
    return Intl.message(
      'Allah the Almighty said',
      name: 'titlenotifi8',
      desc: '',
      args: [],
    );
  }

  /// `Allah the Almighty said`
  String get titlenotifi9 {
    return Intl.message(
      'Allah the Almighty said',
      name: 'titlenotifi9',
      desc: '',
      args: [],
    );
  }

  /// `Allah the Almighty said`
  String get titlenotifi10 {
    return Intl.message(
      'Allah the Almighty said',
      name: 'titlenotifi10',
      desc: '',
      args: [],
    );
  }

  /// `Protection in Remembrance`
  String get titlenotifi11 {
    return Intl.message(
      'Protection in Remembrance',
      name: 'titlenotifi11',
      desc: '',
      args: [],
    );
  }

  /// `O Allah, truly I ask You to make my heart healthy!`
  String get bodynotifi1 {
    return Intl.message(
      'O Allah, truly I ask You to make my heart healthy!',
      name: 'bodynotifi1',
      desc: '',
      args: [],
    );
  }

  /// `Whoever does not show mercy will not be shown mercy by Allah. (Muslim)`
  String get bodynotifi2 {
    return Intl.message(
      'Whoever does not show mercy will not be shown mercy by Allah. (Muslim)',
      name: 'bodynotifi2',
      desc: '',
      args: [],
    );
  }

  /// `A Muslim is the one from whose tongue and hand others are safe.`
  String get bodynotifi3 {
    return Intl.message(
      'A Muslim is the one from whose tongue and hand others are safe.',
      name: 'bodynotifi3',
      desc: '',
      args: [],
    );
  }

  /// `A smile to your brother's face is a charity.`
  String get bodynotifi4 {
    return Intl.message(
      'A smile to your brother\'s face is a charity.',
      name: 'bodynotifi4',
      desc: '',
      args: [],
    );
  }

  /// `Allah's pleasure lies in the satisfaction of parents. Allah's displeasure lies in their anger. (Tirmidhi)`
  String get bodynotifi5 {
    return Intl.message(
      'Allah\'s pleasure lies in the satisfaction of parents. Allah\'s displeasure lies in their anger. (Tirmidhi)',
      name: 'bodynotifi5',
      desc: '',
      args: [],
    );
  }

  /// `Let him who believes in Allah and the Last Day either speak good or remain silent.`
  String get bodynotifi6 {
    return Intl.message(
      'Let him who believes in Allah and the Last Day either speak good or remain silent.',
      name: 'bodynotifi6',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me, and I will remember you. (Al-Baqarah: 152)`
  String get bodynotifi7 {
    return Intl.message(
      'Remember Me, and I will remember you. (Al-Baqarah: 152)',
      name: 'bodynotifi7',
      desc: '',
      args: [],
    );
  }

  /// `O you who have believed, remember Allah with much remembrance (Al-Ahzab: 41).`
  String get bodynotifi8 {
    return Intl.message(
      'O you who have believed, remember Allah with much remembrance (Al-Ahzab: 41).',
      name: 'bodynotifi8',
      desc: '',
      args: [],
    );
  }

  /// `And for men and women who engage much in Allah's remembrance, Allah has prepared forgiveness and a great reward. (Al-Ahzab: 35)`
  String get bodynotifi9 {
    return Intl.message(
      'And for men and women who engage much in Allah\'s remembrance, Allah has prepared forgiveness and a great reward. (Al-Ahzab: 35)',
      name: 'bodynotifi9',
      desc: '',
      args: [],
    );
  }

  /// `Verily, in the remembrance of Allah do hearts find rest. (Ar-Ra'd: 28)`
  String get bodynotifi10 {
    return Intl.message(
      'Verily, in the remembrance of Allah do hearts find rest. (Ar-Ra\'d: 28)',
      name: 'bodynotifi10',
      desc: '',
      args: [],
    );
  }

  /// `A servant (of Allah) is shielded from Satan when he remembers Allah.`
  String get bodynotifi11 {
    return Intl.message(
      'A servant (of Allah) is shielded from Satan when he remembers Allah.',
      name: 'bodynotifi11',
      desc: '',
      args: [],
    );
  }

  /// `Your support helps us improve and expand the application. We value any form of support that promotes the revival of the Sunnah of the Prophet (ﷺ), whether it be financial assistance or spreading information about our application. We are grateful for any help. As Allah the Almighty said in His Holy Book:`
  String get supportText1 {
    return Intl.message(
      'Your support helps us improve and expand the application. We value any form of support that promotes the revival of the Sunnah of the Prophet (ﷺ), whether it be financial assistance or spreading information about our application. We are grateful for any help. As Allah the Almighty said in His Holy Book:',
      name: 'supportText1',
      desc: '',
      args: [],
    );
  }

  /// `And hasten towards forgiveness from your Lord and a Paradise as vast as the heavens and the earth, prepared for those mindful ˹of Allah. They are˺ those who donate in prosperity and adversity, control their anger, and pardon others. And Allah loves the good-doers`
  String get supportText2 {
    return Intl.message(
      'And hasten towards forgiveness from your Lord and a Paradise as vast as the heavens and the earth, prepared for those mindful ˹of Allah. They are˺ those who donate in prosperity and adversity, control their anger, and pardon others. And Allah loves the good-doers',
      name: 'supportText2',
      desc: '',
      args: [],
    );
  }

  /// `(Surah Ali 'Imran 133) It is narrated from Abu Hurairah that the Prophet of Allah (ﷺ) said:`
  String get supportText3 {
    return Intl.message(
      '(Surah Ali \'Imran 133) It is narrated from Abu Hurairah that the Prophet of Allah (ﷺ) said:',
      name: 'supportText3',
      desc: '',
      args: [],
    );
  }

  /// `When a man dies, his deeds come to an end except for three things: Sadaqah Jariyah (ceaseless charity); a knowledge which is beneficial, or a virtuous descendant who prays for him (for the deceased). (Muslim:1631)`
  String get supportText4 {
    return Intl.message(
      'When a man dies, his deeds come to an end except for three things: Sadaqah Jariyah (ceaseless charity); a knowledge which is beneficial, or a virtuous descendant who prays for him (for the deceased). (Muslim:1631)',
      name: 'supportText4',
      desc: '',
      args: [],
    );
  }

  /// `With the permission of the Most High, we will continue to work on improving the application. All praise is due to Allah, the Lord of the worlds!`
  String get supportText5 {
    return Intl.message(
      'With the permission of the Most High, we will continue to work on improving the application. All praise is due to Allah, the Lord of the worlds!',
      name: 'supportText5',
      desc: '',
      args: [],
    );
  }

  /// `If you want to financially support our project, please contact us via email at ulamuyaman@gmail.com`
  String get supportText6 {
    return Intl.message(
      'If you want to financially support our project, please contact us via email at ulamuyaman@gmail.com',
      name: 'supportText6',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite chapters will be displayed here`
  String get favoriteText {
    return Intl.message(
      'Your favorite chapters will be displayed here',
      name: 'favoriteText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tj'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
