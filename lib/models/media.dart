import 'package:sembast/timestamp.dart';

class Media {
  final String uri;

  final String? title;
  final String? artist;
  final String? album;
  final String? trackNumber;

  int playCount;
  int skipCount;
  Timestamp? lastPlayedTimestamp;
  Timestamp? lastSkippedTimestamp;

  Media({
    required this.uri,
    this.title,
    this.artist,
    this.album,
    this.trackNumber,
    required this.playCount,
    required this.skipCount,
    this.lastPlayedTimestamp,
    this.lastSkippedTimestamp,
  });

  Map<String, dynamic> toMediaMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'trackNumber': trackNumber,
      'playCount': playCount,
      'skipCount': skipCount,
      'lastPlayedTimestamp': lastPlayedTimestamp,
      'lastSkippedTimestamp': lastSkippedTimestamp,
    };
  }

  Map<String, dynamic> toFileMap() {
    return {
      'playCount': playCount,
      'skipCount': skipCount,
      'lastPlayedTimestamp': lastPlayedTimestamp,
      'lastSkippedTimestamp': lastSkippedTimestamp,
    };
  }

  Media.fromMap(Map<String, dynamic> map)
      : uri = map['uri'],
        title = map['title'],
        artist = map['artist'],
        album = map['album'],
        trackNumber = map['trackNumber'],
        playCount = map['playCount'],
        skipCount = map['skipCount'],
        lastPlayedTimestamp = map['lastPlayedTimestamp'],
        lastSkippedTimestamp = map['lastSkippedTimestamp'];
}
