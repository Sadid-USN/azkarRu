class BooksRu {
  String? urlImage;
  List<String>? name;
  List<String>? path;

  BooksRu({this.path, this.name, this.urlImage});
}

class BooksInPersian {
  final String? name;
  final String? path;
  final String? imgUrl;
  final BooksPer? booksPer;
  BooksInPersian({this.name, this.path, this.imgUrl, this.booksPer});
}

final booksRu = BooksRu(
  name: [
   
    'Причины увеличения и уменьшения веры',
    'Ангелы с точки зрения Ислама',
    'О вхождении джинов в тело человека',
    'Доказательства единобожия',
    'С кем будет женщина в Раю?',
  ],
  path: [

        'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/04_prichini_uvelicheniya_i_umensheniya_imana.pdf',
    'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/25_angeli.pdf',
    'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/21_o_vhojdenii_djinov.pdf',
    'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/03_dokazat_edinobojiya.pdf',
  ],
  urlImage:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeeldMy09D3Gu3cFubGwHDS-I5KlGkbm-O6g&usqp=CAU',
);

class BooksPer {
  List<String>? booksPer;
  BooksPer({this.booksPer});
}

final List<BooksPer> booksPer = [
  BooksPer(booksPer: [
    'http://aqeedeh.com/book_files/pdf/fa/qoran-ra-chegune-bekhanim-PDF.pdf',
    'http://aqeedeh.com/book_files/pdf/fa/lahazatee-ba-sokhanan-delnasheen-payambar-PDF.pdf',
    'http://aqeedeh.com/book_files/pdf/fa/semay-sorat-va-seerat-zan-dar-islam-PDF.pdf',
    'http://aqeedeh.com/book_files/pdf/fa/seerat-akhlaqi-payambar-PDF.pdf',
  ])
  // BooksInRussian(
  //     imgUrl:
  //         'https://images.unsplash.com/photo-1542816417-0983c9c9ad53?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  //     path:
  //
  //     name: 'قرآن را چگونه بخوانیم؟'),
  // BooksInRussian(
  //     imgUrl:
  //         'https://images.unsplash.com/photo-1627337840960-d55af60bf8e3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80',
  //     path:
  //
  //     name: ' (ﷺ) لحظاتی باسخنان دلنشین پیامبر '),
  // BooksInRussian(
  //     imgUrl:
  //         'https://images.unsplash.com/photo-1464798429116-8e26f96b2e60?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80',
  //     path:
  //
  //     name: 'سیمای صورت و سیرت زن در اسلام'),
  // BooksInRussian(
  //     imgUrl:
  //         'https://images.unsplash.com/photo-1594047543253-43f56592fe1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
  //     path:
  //
  //     name: 'سیرت اخلاقی رسول گرامی (ﷺ) '),
];
