import 'package:sembast/timestamp.dart';

class Track {
  final String uri;

  String? title;
  String? artist;
  String? album;
  String? trackNumber;

  int playCount;
  int skipCount;
  Timestamp? lastPlayedTimestamp;
  Timestamp? lastSkippedTimestamp;

  String? lyrics;

  Track({
    required this.uri,
    this.title,
    this.artist,
    this.album,
    this.trackNumber,
    this.playCount = 0,
    this.skipCount = 0,
    this.lastPlayedTimestamp,
    this.lastSkippedTimestamp,
    this.lyrics,
  });

  Map<String, dynamic> toTrackMap() {
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

  bool isTrackInfoAvailable() {
    return title != null &&
        artist != null &&
        album != null &&
        trackNumber != null;
  }
}
