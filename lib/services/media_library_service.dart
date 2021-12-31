import 'package:discoid/models/media.dart';
import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';

class MediaLibraryService extends ChangeNotifier {
  Map<String, Media> mediaLibrary = <String, Media>{};
  late Future<Database> database;
  var fileStore = stringMapStoreFactory.store('file');
  var mediaStore = intMapStoreFactory.store('media');

  MediaLibraryService() {
    database = () async {
      Database db = await databaseFactoryIo.openDatabase('sample.db');
      return db;
    }();
    () async {
      Database db = await database;

      var files = await fileStore.find(db);

      for (var file in files) {
        ID3Tag tag = ID3TagReader.path(Uri.decodeFull(Uri.parse(file.key).path))
            .readTagSync();

        Media media = Media(
          uri: file.key,
          title: tag.title ?? file.key.split('/').last,
          artist: tag.artist,
          album: tag.album,
          track: tag.track,
          playCount: file.value['playCount'] as int,
          skipCount: file.value['skipCount'] as int,
          lastPlayedTimestamp: file.value['lastPlayedTimestamp'] as Timestamp?,
          lastSkippedTimestamp:
              file.value['lastSkippedTimestamp'] as Timestamp?,
        );

        await syncStores(db, media);
        mediaLibrary[file.key] = media;
      }
      notifyListeners();
    }();
  }

  Future<void> addMediaByUri(final String uri) async {
    Database db = await database;

    if (await fileStore.record(uri).exists(db)) {
      print("addMediaByUri: uri already exists in fileStore");
      return;
    }

    if (mediaLibrary.containsKey(uri)) {
      print("addMediaByUri: uri already exists in mediaLibrary");
      return;
    }

    ID3Tag tag =
        ID3TagReader.path(Uri.decodeFull(Uri.parse(uri).path)).readTagSync();

    Media media = Media(
      uri: uri,
      title: tag.title ?? uri.split('/').last,
      artist: tag.artist,
      album: tag.album,
      track: tag.track,
      playCount: 0,
      skipCount: 0,
      lastPlayedTimestamp: null,
      lastSkippedTimestamp: null,
    );

    await fileStore.record(uri).add(db, media.toFileMap());
    await syncStores(db, media);
    mediaLibrary[uri] = media;
    notifyListeners();
  }

  Future<void> syncStores(final Database db, final Media media) async {
    if (media.title != null &&
        media.artist != null &&
        media.album != null &&
        media.track != null) {
      var result = await mediaStore.findFirst(
        db,
        finder: Finder(
          filter: Filter.and([
            Filter.equals('title', media.title),
            Filter.equals('artist', media.artist),
            Filter.equals('album', media.album),
            Filter.equals('track', media.track),
          ]),
        ),
      );

      if (result == null) {
        await mediaStore.add(db, media.toMediaMap());
      } else {
        media.playCount = result.value['playCount'] as int;
        media.skipCount = result.value['skipCount'] as int;
        media.lastPlayedTimestamp =
            result.value['lastPlayedTimestamp'] as Timestamp?;
        media.lastSkippedTimestamp =
            result.value['lastSkippedTimestamp'] as Timestamp?;
        await fileStore.record(media.uri).update(db, media.toFileMap());
      }
    }
  }
}
