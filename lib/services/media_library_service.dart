import 'package:discoid/models/media.dart';
import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class MediaLibraryService extends ChangeNotifier {
  Map<String, Media> mediaLibrary = <String, Media>{};
  late Future<Database> database;
  var store = stringMapStoreFactory.store('file');

  MediaLibraryService() {
    database = () async {
      Database db = await databaseFactoryIo.openDatabase('sample.db');
      return db;
    }();
    () async {
      Database db = await database;
      var results = await store.find(db);
      for (var result in results) {
        ID3Tag tag =
            ID3TagReader.path(Uri.decodeFull(Uri.parse(result.key).path))
                .readTagSync();
        mediaLibrary[result.key] = Media(
          title: tag.title ?? result.key.split('/').last,
          artist: tag.artist ?? "null",
          album: tag.album ?? "null",
          uri: result.key,
        );
      }
      notifyListeners();
    }();
  }

  void addMediaByUri(final String uri) async {
    ID3Tag tag =
        ID3TagReader.path(Uri.decodeFull(Uri.parse(uri).path)).readTagSync();
    mediaLibrary[uri] = Media(
      title: tag.title ?? uri.split('/').last,
      artist: tag.artist ?? "null",
      album: tag.album ?? "null",
      uri: uri,
    );
    notifyListeners();
    Database db = await database;
    await store.record(uri).add(db, {});
  }
}
