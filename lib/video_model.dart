class VideoModel {
  final String title;
  final String url;
  final String coverImage;

  VideoModel(
      {required this.title, required this.url, required this.coverImage});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'],
      url: json['url'],
      coverImage: json['coverImage'],
    );
  }
}
