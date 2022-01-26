import 'dart:collection';

import 'package:discoid/models/track.dart';

class Album {
  String? name;
  String? albumArtist;
  SplayTreeSet<Track> tracks;

  Album({this.name, this.albumArtist})
      : tracks = SplayTreeSet<Track>((final Track a, final Track b) {
          int result;
          result = (a.discNumber ?? 0).compareTo(b.discNumber ?? 0);
          if (result != 0) return result;
          result = (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0);
          if (result != 0) return result;
          result = (a.title ?? a.uri)
              .toLowerCase()
              .compareTo((b.title ?? b.uri).toLowerCase());
          return result != 0
              ? result
              : a.uri.toLowerCase().compareTo(b.uri.toLowerCase());
        });
}
