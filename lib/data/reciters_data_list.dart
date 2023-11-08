

import 'package:avrod/widgets/radio_audioplayer.dart';

List<InfoData> reciters = [
  InfoData(
    id: "1",
    audioUrl: 'https://s5.radio.co/sdaff9bd16/listen',
    image:
        'https://i.pinimg.com/564x/39/aa/2b/39aa2b0f6647ae3b098820c0285271f2.jpg',
    name: 'furqan-radio',
    subtitle: '24/7',
  ),
  InfoData(
      id: "2",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1',
      name: 'Mohamed Siddiq',
      subtitle: 'al-Minshawi'),
  InfoData(
      id: "3",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/5/mahmoud-khalil-al-hussary-profile.png?v=1',
      name: 'Mahmoud Khalil',
      subtitle: 'Al-Husary'),
  InfoData(
      id: "4",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/abdul_baset/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/1/abdelbasset-profile.jpeg?v=1',
      name: 'AbdulBaset',
      subtitle: 'AbdulSamad'),
  InfoData(
      id: "5",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/6/mishary-rashid-alafasy-profile.jpeg?v=1',
      name: 'Mishari Rashid',
      subtitle: 'al-`Afasy'),
  InfoData(
      id: "6",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://2.bp.blogspot.com/-zbRVES0XunQ/TgRDKGBDG6I/AAAAAAAABuA/2hFmIkeQTqE/s1600/abu-bakr-al-shatri.jpg',
      name: 'Abu Bakr',
      subtitle: 'al-Shatri'),
  InfoData(
      id: "7",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/khalifah_taniji/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/11/khalifa-al-tunaiji-profile.jpeg?v=1',
      name: ' Khalifa Musabah',
      subtitle: 'Al-Tunaiji'),
  InfoData(
      id: "8",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/4/hani-ar-rifai-profile.jpeg?v=1',
      name: 'Sheikh Hani',
      subtitle: 'ar-Rifai'),
];

Map<String, int> quranChapters = {
  "Al-Fatihah": 1,
  "Al-Baqarah": 2,
  "Al-Imran": 3,
  "An-Nisa’": 4,
  "Al-Ma’idah": 5,
  "Al-An’am": 6,
  "Al-A’raf": 7,
  "Al-Anfal": 8,
  "At-Taubah": 9,
  "Yunus": 10,
  "Hud": 11,
  "Yusuf": 12,
  "Ar-Ra’d": 13,
  "Ibrahim": 14,
  "Al-Hijr": 15,
  "An-Nahl": 16,
  "Al-Isra’": 17,
  "Al-Kahf": 18,
  "Maryam": 19,
  "Ta-Ha": 20,
  "Al-Anbiya’": 21,
  "Al-Haj": 22,
  "Al-Mu’minun": 23,
  "An-Nur": 24,
  "Al-Furqan": 25,
  "Ash-Shu’ara’": 26,
  "An-Naml": 27,
  "Al-Qasas": 28,
  "Al-Ankabut": 29,
  "Ar-Rum": 30,
  "Luqman": 31,
  "As-Sajdah": 32,
  "Al-Ahzab": 33,
  "Saba’": 34,
  "Al-Fatir": 35,
  "Ya-Sin": 36,
  "As-Saffah": 37,
  "Sad": 38,
  "Az-Zumar": 39,
  "Ghafar": 40,
  "Fusilat": 41,
  "Ash-Shura": 42,
  "Az-Zukhruf": 43,
  "Ad-Dukhan": 44,
  "Al-Jathiyah": 45,
  "Al-Ahqaf": 46,
  "Muhammad": 47,
  "Al-Fat’h": 48,
  "Al-Hujurat": 49,
  "Qaf": 50,
  "Adz-Dzariyah": 51,
  "At-Tur": 52,
  "An-Najm": 53,
  "Al-Qamar": 54,
  "Ar-Rahman": 55,
  "Al-Waqi’ah": 56,
  "Al-Hadid": 57,
  "Al-Mujadilah": 58,
  "Al-Hashr": 59,
  "Al-Mumtahanah": 60,
  "As-Saf": 61,
  "Al-Jum’ah": 62,
  "Al-Munafiqun": 63,
  "At-Taghabun": 64,
  "At-Talaq": 65,
  "At-Tahrim": 66,
  "Al-Mulk": 67,
  "Al-Qalam": 68,
  "Al-Haqqah": 69,
  "Al-Ma’arij": 70,
  "Nuh": 71,
  "Al-Jinn": 72,
  "Al-Muzammil": 73,
  "Al-Mudaththir": 74,
  "Al-Qiyamah": 75,
  "Al-Insan": 76,
  "Al-Mursalat": 77,
  "An-Naba’": 78,
  "An-Nazi’at": 79,
  "Abasa": 80,
  "At-Takwir": 81,
  "Al-Infitar": 82,
  "Al-Mutaffifin": 83,
  "Al-Inshiqaq": 84,
  "Al-Buruj": 85,
  "At-Tariq": 86,
  "Al-A’la": 87,
  "Al-Ghashiyah": 88,
  "Al-Fajr": 89,
  "Al-Balad": 90,
  "Ash-Shams": 91,
  "Al-Layl": 92,
  "Adh-Dhuha": 93,
  "Ash-Sharh": 94,
  "At-Tin": 95,
  "Al-‘Alaq": 96,
  "Al-Qadar": 97,
  "Al-Bayinah": 98,
  "Az-Zalzalah": 99,
  "Al-‘Adiyah": 100,
  "Al-Qari’ah": 101,
  "At-Takathur": 102,
  "Al-‘Asr": 103,
  "Al-Humazah": 104,
  "Al-Fil": 105,
  "Quraish": 106,
  "Al-Ma’un": 107,
  "Al-Kauthar": 108,
  "Al-Kafirun": 109,
  "An-Nasr": 110,
  "Al-Masad": 111,
  "Al-Ikhlas": 112,
  "Al-Falaq": 113,
  "An-Nas": 114,
};


  // Align(
  //                 alignment: Alignment.topRight,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 20),
  //                   child: 
                    
  //                   PopupMenuButton<int>(
  //                     icon: const Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Text("Surahs"),
  //                         Icon(Icons.arrow_drop_down)
  //                       ],
  //                     ),
  //                     onSelected: (int surah) {
                                  
  //                       print('Selected surah: $surah');
  //                     },
  //                     itemBuilder: (BuildContext context) {
                      
  //                       return quranChapters.entries
  //                           .map((entry) => PopupMenuItem<int>(
  //                                 value: entry.value,
  //                                 child: Text(entry.key),
  //                               ))
  //                           .toList();
  //                     },
  //                   ),
  //                 ),
  //               ),