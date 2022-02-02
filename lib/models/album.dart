import 'dart:collection';

import 'package:discoid/models/artist.dart';
import 'package:discoid/models/track.dart';

class Album {
  String? name;
  Artist albumArtist;
  SplayTreeSet<Track> tracks;

  Album({this.name, Artist? albumArtist})
      : albumArtist = albumArtist ?? Artist(),
        tracks = SplayTreeSet<Track>((final Track a, final Track b) {
          int result;
          result = (a.discNumber ?? 0).compareTo(b.discNumber ?? 0);
          if (result != 0) return result;
          result = (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0);
          if (result != 0) return result;
          result = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          return result != 0
              ? result
              : a.uri.toLowerCase().compareTo(b.uri.toLowerCase());
        });
}
