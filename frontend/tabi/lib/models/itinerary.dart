/// Base class for all block types
abstract class ItineraryBlock {
  final String type;
  ItineraryBlock(this.type);

  /// Reads a block from JSON
  factory ItineraryBlock.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'text':
        return TextBlock.fromJson(json);
      case 'photo':
        return PhotoBlock.fromJson(json);
      case 'video':
        return VideoBlock.fromJson(json);
      default:
        throw UnsupportedError('Unknown block type: ${json['type']}');
    }
  }
}

class TextBlock extends ItineraryBlock {
  final String content;
  TextBlock(this.content) : super('text');

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(json['content'] as String);
  }
}

class PhotoBlock extends ItineraryBlock {
  final String url;
  PhotoBlock(this.url) : super('photo');

  factory PhotoBlock.fromJson(Map<String, dynamic> json) {
    return PhotoBlock(json['url'] as String);
  }
}

class VideoBlock extends ItineraryBlock {
  final String url;
  VideoBlock(this.url) : super('video');

  factory VideoBlock.fromJson(Map<String, dynamic> json) {
    return VideoBlock(json['url'] as String);
  }
}

class ItineraryStatic {
  final int id;
  final String title;
  final String destination;
  final int days;
  final String userName;
  final int likes;
  final int forks;
  final int saves;

  /// New: a single, ordered list of all block types
  final List<ItineraryBlock> blocks;

  ItineraryStatic({
    required this.id,
    required this.title,
    required this.destination,
    required this.days,
    required this.userName,
    required this.likes,
    required this.forks,
    required this.saves,
    required this.blocks,
  });

  factory ItineraryStatic.fromJson(Map<String, dynamic> json) {
    // Parse the blocks array:
    final rawBlocks = json['blocks'] as List<dynamic>? ?? [];
    final blocks = rawBlocks
        .map((b) => ItineraryBlock.fromJson(b as Map<String, dynamic>))
        .toList();

    return ItineraryStatic(
      id: json['id'] as int,
      title: json['title'] as String,
      destination: json['destination'] as String,
      days: json['days'] as int,
      userName: json['user_name'] as String,
      likes: json['likes'] as int,
      forks: json['forks'] as int,
      saves: json['saves'] as int,
      blocks: blocks,
    );
  }
}