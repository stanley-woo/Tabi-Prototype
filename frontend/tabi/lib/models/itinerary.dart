class ItineraryStatic {
  final int id;
  final String title;
  final String destination;
  final int days;
  final String userName;
  final String imageUrl;
  final int likes;
  final int forks;
  final int saves;
  final List<String> photoUrls;
  final List<String> videoUrls;

  ItineraryStatic({
    required this.id,
    required this.title,
    required this.destination,
    required this.days,
    required this.userName,
    required this.imageUrl,
    required this.likes,
    required this.forks,
    required this.saves,
    required this.photoUrls,
    required this.videoUrls,
  });

  factory ItineraryStatic.fromJson(Map<String, dynamic> json) {
    return ItineraryStatic(
      id: json['id'],
      title: json['title'],
      destination: json['destination'],
      days: json['days'],
      userName: json['user_name'],
      imageUrl: json['image_url'],
      likes: json['likes'],
      forks: json['forks'],
      saves: json['saves'],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      videoUrls: List<String>.from(json['video_urls'] ?? []),
    );
  }
}