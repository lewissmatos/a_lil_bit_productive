class ShortStoriesResponseModel {
  final String id;
  final String title;
  final String author;
  final String story;
  final String moral;

  ShortStoriesResponseModel({
    required this.id,
    required this.title,
    required this.author,
    required this.story,
    required this.moral,
  });

  ShortStoriesResponseModel copyWith({
    String? id,
    String? title,
    String? author,
    String? story,
    String? moral,
  }) =>
      ShortStoriesResponseModel(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        story: story ?? this.story,
        moral: moral ?? this.moral,
      );

  factory ShortStoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      ShortStoriesResponseModel(
        id: json["_id"],
        title: json["title"],
        author: json["author"],
        story: json["story"],
        moral: json["moral"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "author": author,
        "story": story,
        "moral": moral,
      };
}
