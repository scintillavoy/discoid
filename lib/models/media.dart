class Media {
  final String title;
  final String artist;
  final String album;
  final String uri;

  Media({
    required this.title,
    required this.artist,
    required this.album,
    required this.uri,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'uri': uri,
    };
  }

  Media.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        artist = map['artist'],
        album = map['album'],
        uri = map['uri'];
}
