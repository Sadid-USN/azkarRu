import 'package:equatable/equatable.dart';

class LibBookModel extends Equatable {
  final String? id;
  final String? author;
  final String? category;
  final String? published;
  final String? lang;
  final String? title;
  final String? image;
  final List<LibChapters>? chapters;

  const LibBookModel({
    this.id,
    this.author,
    this.category,
    this.published,
    this.lang,
    this.title,
    this.image,
    this.chapters,
  });

  @override
  List<Object?> get props => [id, author, category, published, lang, title, image, chapters];

  factory LibBookModel.fromJson(Map<String, dynamic> json) {
    return LibBookModel(
      id: json['id'] as String?,
      author: json['author'] as String?,
      category: json['category'] as String?,
      published: json['published'] as String?,
      lang: json['lang'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      chapters: (json['chapters'] as List?)?.map((dynamic e) => LibChapters.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'category': category,
      'published': published,
      'lang': lang,
      'title': title,
      'image': image,
      'chapters': chapters?.map((e) => e.toJson()).toList(),
    };
  }
}

class LibChapters extends Equatable {
  final int? id;
  final String? subtitle;
  final String? text;
  final String? url;
  final bool? isAudioUrl;
  final List<Sources>? sources;

  const LibChapters({
    this.id,
    this.subtitle,
    this.text,
    this.url,
    this.isAudioUrl,
    this.sources,
  });

  @override
  List<Object?> get props => [id, subtitle, text, url, isAudioUrl, sources];

  factory LibChapters.fromJson(Map<String, dynamic> json) {
    return LibChapters(
      id: json['id'] as int?,
      subtitle: json['subtitle'] as String?,
      text: json['text'] as String?,
      url: json['url'] as String?,
      isAudioUrl: json['isAudioUrl'] as bool?,
      sources: (json['sources'] as List?)?.map((dynamic e) => Sources.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subtitle': subtitle,
      'text': text,
      'url': url,
      'isAudioUrl': isAudioUrl,
      'sources': sources?.map((e) => e.toJson()).toList(),
    };
  }
}

class Sources extends Equatable {
  final String? source;

  const Sources({
    this.source,
  });

  @override
  List<Object?> get props => [source];

  factory Sources.fromJson(Map<String, dynamic> json) {
    return Sources(
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
    };
  }
}
