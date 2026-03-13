import 'dart:convert';

/// 顶层响应
class ManyACGApiResponse {
  final int status;
  final String message;
  final List<Item> data;

  ManyACGApiResponse({required this.status, required this.message, required this.data});

  factory ManyACGApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Item> items = list.map((i) => Item.fromJson(i)).toList();

    return ManyACGApiResponse(
      status: json['status'],
      message: json['message'],
      data: items,
    );
  }

  /// 方便直接解析字符串
  static ManyACGApiResponse fromJsonString(String jsonString) {
    final Map<String, dynamic> parsed = jsonDecode(jsonString);
    return ManyACGApiResponse.fromJson(parsed);
  }
}

/// 作品条目
class Item {
  final String id;
  final String createdAt;
  final String title;
  final String description;
  final String sourceUrl;
  final bool r18;
  final int likeCount;
  final List<String> tags;
  final Artist artist;
  final List<Picture> pictures;

  Item({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.sourceUrl,
    required this.r18,
    required this.likeCount,
    required this.tags,
    required this.artist,
    required this.pictures,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    var tagsFromJson = List<String>.from(json['tags']);
    var picturesFromJson = (json['pictures'] as List)
        .map((p) => Picture.fromJson(p))
        .toList();

    return Item(
      id: json['id'],
      createdAt: json['created_at'],
      title: json['title'],
      description: json['description'],
      sourceUrl: json['source_url'],
      r18: json['r18'],
      likeCount: json['like_count'],
      tags: tagsFromJson,
      artist: Artist.fromJson(json['artist']),
      pictures: picturesFromJson,
    );
  }
}

/// 作者信息
class Artist {
  final String id;
  final String name;
  final String type;
  final String uid;
  final String username;

  Artist({
    required this.id,
    required this.name,
    required this.type,
    required this.uid,
    required this.username,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      uid: json['uid'],
      username: json['username'],
    );
  }
}

/// 图片信息
class Picture {
  final String id;
  final int width;
  final int height;
  final int index;
  final String fileName;
  final String thumbnail;
  final String regular;

  Picture({
    required this.id,
    required this.width,
    required this.height,
    required this.index,
    required this.fileName,
    required this.thumbnail,
    required this.regular,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      index: json['index'],
      fileName: json['file_name'],
      thumbnail: json['thumbnail'],
      regular: json['regular'],
    );
  }
}