class Book {
  final int? id;
  final String? name;
  final String? image;
  final List<Chapters>? chapters;

  Book({
    this.id,
    this.name,
    this.image,
    this.chapters,
  });

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?,
        chapters = (json['chapters'] as List?)
            ?.map((dynamic e) => Chapters.fromJson(e as Map<String, dynamic>))
            .toList();

 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  {};
  data['id'] = id;
  data['name'] = name;
  data['image'] = image;
  data['chapters'] = chapters?.map((chapter) => chapter.toJson()).toList();
  return data;
}
}

class Chapters {
  final int? id;
  final String? listimage;
  final String? name;
  final List<Texts>? texts;

  Chapters({
    this.id,
    this.listimage,
    this.name,
    this.texts,
  });

  Chapters.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        listimage = json['listimage'] as String?,
        name = json['name'] as String?,
        texts = (json['texts'] as List?)
            ?.map((dynamic e) => Texts.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'listimage': listimage,
        'name': name,
        'texts': texts?.map((e) => e.toJson()).toList()
      };
}

class Texts {
  final String? id;
  final String? text;
  final String? arabic;
  final String? translation;
  final String? url;

  Texts({
    this.id,
    this.text,
    this.arabic,
    this.translation,
    this.url,
  });

  Texts.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        text = json['text'] as String?,
        arabic = json['arabic'] as String?,
        translation = json['translation'] as String?,
        url = json['url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'arabic': arabic,
        'translation': translation,
        'url': url
      };
}
