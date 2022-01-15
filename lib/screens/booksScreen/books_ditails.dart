class BooksRu {
  List<String>? urlImage;
  List<String>? name;
  List<String>? path;

  BooksRu({this.path, this.name, this.urlImage});
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
  '',
  '',
  '',
  'Причины увеличения и уменьшения веры',
  '',
  'О вхождении джинов в тело человека',
  '',
  'С кем будет женщина в Раю?',
  'پاسخ به 18 شبهه برگزارکنندگان جشن میلاد پیامبر',
  'اصول و مبانی دعوت در سیرت پیامبر رحمت',
], path: [
  "https://docs.google.com/viewerng/viewer?hl=ar&t=59&url=https://www.alarabimag.com/books/23160.pdf",
  "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/05_fiqh/09_raznoe/08_umdatul_ahkam_1_tom.pdf",
  "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/08_adab/01_deyaniya_obereg_raba.pdf",
  "https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/04_prichini_uvelicheniya_i_umensheniya_imana.pdf",
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/25_angeli.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/21_o_vhojdenii_djinov.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/27_poslanniki.pdf',
  'https://static.toislam.ws/files/biblioteka/biblioteka_pdf/01_aqida/14_s_kem_jenshina_v_rayu.pdf',
  'https://aqeedeh.com/book_files/pdf/fa/pasokh-ba-18shobhe-jashn-milad-peyambar-PDF.pdf',
  'https://aqeedeh.com/book_files/pdf/fa/osul-va-mabani-davat-dar-sirat-payambar-PDF.pdf',
], urlImage: [
  'https://www.almrsal.com/wp-content/uploads/2018/11/%D8%A7%D9%84%D9%82%D8%A7%D8%B9%D8%AF%D8%A9-%D8%A7%D9%84%D9%86%D9%88%D8%B1%D8%A7%D9%86%D9%8A%D8%A9.png',
  'https://toislam.ws/wp-content/uploads/2022/01/sharkh_umdat_al_ahkam_1-830x402.jpg',
  'https://toislam.ws/wp-content/uploads/2013/05/deyaniya_raba-830x402.jpg',
  'https://i.pinimg.com/originals/e7/3a/52/e73a52cf5dfeb4bfeb9979ba1487947c.jpg',
  'https://toislam.ws/wp-content/uploads/2013/08/angeli_islam-830x402.jpg',
  'https://toislam.ws/wp-content/uploads/2013/05/djinni-830x402.jpg',
  'https://toislam.ws/wp-content/uploads/2013/10/proroki-830x402.jpg',
  'https://cdn.statically.io/img/i.pinimg.com/originals/f3/7d/c5/f37dc5e4ea716ad61962daf36a070c0d.jpg',
  'https://cdn.pixabay.com/photo/2020/07/12/09/41/mosque-5396683_960_720.jpg',
  'https://www.wallpapertip.com/wmimgs/49-499602_download-data-src-wallpaper-mosque-hd-1080p-sheikh.jpg',
]);
