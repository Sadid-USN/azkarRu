class LibBookModel {
  final String? id;
  final String? author;
  final String? title;
  final String? image;
  final List<Chapters>? chapters;

  LibBookModel({
    this.id,
    this.author,
    this.title,
    this.image,
    this.chapters,
  });

  LibBookModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String?,
      author = json['author'] as String?,
      title = json['title'] as String?,
      image = json['image'] as String?,
      chapters = (json['chapters'] as List?)?.map((dynamic e) => Chapters.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'author' : author,
    'title' : title,
    'image' : image,
    'chapters' : chapters?.map((e) => e.toJson()).toList()
  };
}

class Chapters {
  final String? subtitle;
  final String? text;
  final List<Sources>? sources;

  Chapters({
    this.subtitle,
    this.text,
    this.sources,
  });

  Chapters.fromJson(Map<String, dynamic> json)
    : subtitle = json['subtitle'] as String?,
      text = json['text'] as String?,
      sources = (json['sources'] as List?)?.map((dynamic e) => Sources.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'subtitle' : subtitle,
    'text' : text,
    'sources' : sources?.map((e) => e.toJson()).toList()
  };
}

class Sources {
  final String? source;

  Sources({
    this.source,
  });

  Sources.fromJson(Map<String, dynamic> json)
    : source = json['source'] as String?;

  Map<String, dynamic> toJson() => {
    'source' : source
  };
}