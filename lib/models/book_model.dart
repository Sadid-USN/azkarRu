// class BookModel {
//   final int? id;
//   final String? author;
//   final String? name;
//   final String? preface;
//   final String? image;
//   final List<Chapters>? chapters;

//   BookModel({
//     this.id,
//     this.author,
//     this.name,
//     this.preface,
//     this.image,
//     this.chapters,
//   });

//   BookModel.fromJson(Map<String, dynamic> json)
//     : id = json['id'] as int?,
//       author = json['author'] as String?,
//       name = json['name'] as String?,
//       preface = json['preface'] as String?,
//       image = json['image'] as String?,
//       chapters = (json['chapters'] as List?)?.map((dynamic e) => Chapters.fromJson(e as Map<String,dynamic>)).toList();

//   Map<String, dynamic> toJson() => {
//     'id' : id,
//     'author' : author,
//     'name' : name,
//     'preface' : preface,
//     'image' : image,
//     'chapters' : chapters?.map((e) => e.toJson()).toList()
//   };
// }

// class Chapters {
//   final int? id;
//   final String? title;
//   final String? text;
//   final String? arabic;
//   final String? source;

//   Chapters({
//     this.id,
//     this.title,
//     this.text,
//     this.arabic,
//     this.source,
//   });

//   Chapters.fromJson(Map<String, dynamic> json)
//     : id = json['id'] as int?,
//       title = json['title'] as String?,
//       text = json['text'] as String?,
//       arabic = json['arabic'] as String?,
//       source = json['source'] as String?;

//   Map<String, dynamic> toJson() => {
//     'id' : id,
//     'title' : title,
//     'text' : text,
//     'arabic' : arabic,
//     'source' : source
//   };
// }