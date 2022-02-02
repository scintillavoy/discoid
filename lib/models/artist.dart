import 'dart:collection';

import 'package:discoid/models/album.dart';

class Artist {
  String? name;
  SplayTreeSet<Album> albums;

  Artist({this.name})
      : albums = SplayTreeSet<Album>((final Album a, final Album b) {
          return (a.name ?? "")
              .toLowerCase()
              .compareTo((b.name ?? "").toLowerCase());
        });
}
