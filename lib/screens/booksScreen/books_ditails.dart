class BooksRu {

  List<String>? name;
  List<String>? path;

  BooksRu({this.path, this.name,});
}

class BooksInPersian {
  final String? name;
  final String? path;
  final String? imgUrl;

  BooksInPersian({
    this.name,
    this.path,
    this.imgUrl,
  });
}

final booksRu = BooksRu(name: [
  "Being Truthful with Allah",
  "Noble Manners",
  "Advice",
  'Деяния, оберегающие раба Аллаха',
  'Причины увеличения и уменьшения веры',
  'Ангелы с точки зрения Ислама',
  'О вхождении джинов в тело человека',
  'Посланники и пророки в свете Ислама',
  'С кем будет женщина в Раю?',
  'پاسخ به 18 شبهه برگزارکنندگان جشن میلاد پیامبر',
  'اصول و مبانی دعوت در سیرت پیامبر رحمت',
], path: [

  "https://darpdfs.org/wp-content/uploads/2020/12/Being-Truthful-with-Allah-Sh.-Abdur-Razzaq-al-Badr-1.pdf",
  "https://darpdfs.org/wp-content/uploads/2021/09/Noble-Manners-is-based-upon-Four-Pillars-Sh.-%E2%80%98Abdur-Razzaq-al-Badr.pdf",
  "https://www.kalamullah.com/Books/Advice-Regarding-The-Book-Of-Allah-Exp.-by-Sh.-Abdur-Razzaq-al-Badr.pdf",
  "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/08_adab/01_deyaniya_obereg_raba.pdf",
  "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/04_prichini_uvelicheniya_i_umensheniya_imana.pdf",
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/25_angeli.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/21_o_vhojdenii_djinov.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/27_poslanniki.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/14_s_kem_jenshina_v_rayu.pdf',
  'https://aqeedeh.com/book_files/pdf/fa/pasokh-ba-18shobhe-jashn-milad-peyambar-PDF.pdf',
  'https://aqeedeh.com/book_files/pdf/fa/osul-va-mabani-davat-dar-sirat-payambar-PDF.pdf',
],);
