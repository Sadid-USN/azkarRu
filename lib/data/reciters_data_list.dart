import 'package:avrod/widgets/radio_audioplayer.dart';

List<InfoData> reciters = [
  InfoData(
    id: "1",
    audioUrl: 'https://s5.radio.co/sdaff9bd16/listen',
    image:
        'https://i.pinimg.com/564x/39/aa/2b/39aa2b0f6647ae3b098820c0285271f2.jpg',
    name: 'furqan-radio',
    subtitle: 'Furqan Radio 24/7',
  ),
  InfoData(
      id: "2",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1',
      name: '',
      subtitle: 'Mohamed Siddiq al-Minshawi'),
  InfoData(
      id: "3",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/5/mahmoud-khalil-al-hussary-profile.png?v=1',
      name: '',
      subtitle: 'Mahmoud Khalil Al-Husary'),
  InfoData(
      id: "4",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/abdul_baset/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/1/abdelbasset-profile.jpeg?v=1',
      name: '',
      subtitle: 'AbdulBaset AbdulSamad'),
  InfoData(
      id: "5",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/6/mishary-rashid-alafasy-profile.jpeg?v=1',
      name: '',
      subtitle: 'Mishari Rashid Al-`Afasy'),
  InfoData(
      id: "6",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://2.bp.blogspot.com/-zbRVES0XunQ/TgRDKGBDG6I/AAAAAAAABuA/2hFmIkeQTqE/s1600/abu-bakr-al-shatri.jpg',
      name: '',
      subtitle: 'Abu Bakr Al-Shatri'),
  InfoData(
      id: "7",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/khalifah_taniji/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/11/khalifa-al-tunaiji-profile.jpeg?v=1',
      name: '',
      subtitle: 'Khalifa Musabah Al-Tunaiji'),
  InfoData(
      id: "8",
      // audioUrl:
      //     'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/4/hani-ar-rifai-profile.jpeg?v=1',
      name: '',
      subtitle: 'Sheikh Hani ar-Rifai'),
];

Map<String, int> quranChapters = {
  "1-Al-Fatihah": 1,
  "2-Al-Baqarah": 2,
  "3-Al-Imran": 3,
  "4-An-Nisa’": 4,
  "5-Al-Ma’idah": 5,
  "6-Al-An’am": 6,
  "7-Al-A’raf": 7,
  "8-Al-Anfal": 8,
  "9-At-Taubah": 9,
  "10-Yunus": 10,
  "11-Hud": 11,
  "12-Yusuf": 12,
  "13-Ar-Ra’d": 13,
  "14-Ibrahim": 14,
  "15-Al-Hijr": 15,
  "16-An-Nahl": 16,
  "17-Al-Isra’": 17,
  "18-Al-Kahf": 18,
  "19-Maryam": 19,
  "20-Ta-Ha": 20,
  "21-Al-Anbiya’": 21,
  "22-Al-Haj": 22,
  "23-Al-Mu’minun": 23,
  "24-An-Nur": 24,
  "25-Al-Furqan": 25,
  "26-Ash-Shu’ara’": 26,
  "27-An-Naml": 27,
  "28-Al-Qasas": 28,
  "29-Al-Ankabut": 29,
  "30-Ar-Rum": 30,
  "31-Luqman": 31,
  "32-As-Sajdah": 32,
  "33-Al-Ahzab": 33,
  "34-Saba’": 34,
  "35-Al-Fatir": 35,
  "36-Ya-Sin": 36,
  "37-As-Saffah": 37,
  "38-Sad": 38,
  "39-Az-Zumar": 39,
  "40-Ghafar": 40,
  "41-Fusilat": 41,
  "42-Ash-Shura": 42,
  "43-Az-Zukhruf": 43,
  "44-Ad-Dukhan": 44,
  "45-Al-Jathiyah": 45,
  "46-Al-Ahqaf": 46,
  "47-Muhammad": 47,
  "48-Al-Fat’h": 48,
  "49-Al-Hujurat": 49,
  "50-Qaf": 50,
  "51-Adz-Dzariyah": 51,
  "52-At-Tur": 52,
  "53-An-Najm": 53,
  "54-Al-Qamar": 54,
  "55-Ar-Rahman": 55,
  "56-Al-Waqi’ah": 56,
  "57-Al-Hadid": 57,
  "58-Al-Mujadilah": 58,
  "59-Al-Hashr": 59,
  "60-Al-Mumtahanah": 60,
  "61-As-Saf": 61,
  "62-Al-Jum’ah": 62,
  "63-Al-Munafiqun": 63,
  "64-At-Taghabun": 64,
  "65-At-Talaq": 65,
  "66-At-Tahrim": 66,
  "67-Al-Mulk": 67,
  "68-Al-Qalam": 68,
  "69-Al-Haqqah": 69,
  "70-Al-Ma’arij": 70,
  "71-Nuh": 71,
  "72-Al-Jinn": 72,
  "73-Al-Muzammil": 73,
  "74-Al-Mudaththir": 74,
  "75-Al-Qiyamah": 75,
  "76-Al-Insan": 76,
  "77-Al-Mursalat": 77,
  "78-An-Naba’": 78,
  "79-An-Nazi’at": 79,
  "80-Abasa": 80,
  "81-At-Takwir": 81,
  "82-Al-Infitar": 82,
  "83-Al-Mutaffifin": 83,
  "84-Al-Inshiqaq": 84,
  "85-Al-Buruj": 85,
  "86-At-Tariq": 86,
  "87-Al-A’la": 87,
  "88-Al-Ghashiyah": 88,
  "89-Al-Fajr": 89,
  "90-Al-Balad": 90,
  "91-Ash-Shams": 91,
  "92-Al-Layl": 92,
  "93-Adh-Dhuha": 93,
  "94-Ash-Sharh": 94,
  "95-At-Tin": 95,
  "96-Al-‘Alaq": 96,
  "97-Al-Qadar": 97,
  "98-Al-Bayinah": 98,
  "99-Az-Zalzalah": 99,
  "100-Al-‘Adiyah": 100,
  "101-Al-Qari’ah": 101,
  "102-At-Takathur": 102,
  "103-Al-‘Asr": 103,
  "104-Al-Humazah": 104,
  "105-Al-Fil": 105,
  "106-Quraish": 106,
  "107-Al-Ma’un": 107,
  "108-Al-Kauthar": 108,
  "109-Al-Kafirun": 109,
  "110-An-Nasr": 110,
  "111-Al-Masad": 111,
  "112-Al-Ikhlas": 112,
  "113-Al-Falaq": 113,
  "114-An-Nas": 114,
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