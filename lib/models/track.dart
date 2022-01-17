import 'dart:typed_data';

import 'package:sembast/timestamp.dart';

class Track {
  final String uri;

  String? title;
  String? artist;
  String? album;
  String? trackNumber;
  String? discNumber;

  int playCount;
  int skipCount;
  Timestamp? lastPlayedTimestamp;
  Timestamp? lastSkippedTimestamp;

  String? lyrics;
  Uint8List? artwork;

  Track({
    required this.uri,
    this.title,
    this.artist,
    this.album,
    this.trackNumber,
    this.discNumber,
    this.playCount = 0,
    this.skipCount = 0,
    this.lastPlayedTimestamp,
    this.lastSkippedTimestamp,
    this.lyrics,
    this.artwork,
  });

  Map<String, dynamic> toTrackMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'trackNumber': trackNumber,
      'discNumber': discNumber,
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
    return title != null && artist != null;
  }
}
