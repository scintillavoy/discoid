import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:discoid/models/track.dart';
import 'package:discoid/services/audio_player_service.dart';
import 'package:flac_metadata/flacstream.dart';
import 'package:flac_metadata/metadata.dart';
import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart' as id3tag;
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/timestamp.dart';

class MediaLibraryService extends ChangeNotifier {
  late Future<Database> database;
  var fileStore = stringMapStoreFactory.store('file');
  var trackStore = intMapStoreFactory.store('track');

  StreamSubscription<Duration>? increasePlayCountSubscription;
  SplayTreeSet<Track> allTracks =
      SplayTreeSet<Track>((final Track a, final Track b) {
    String a_ = a.title ?? a.uri;
    int result = a_.compareTo(b.title ?? b.uri);
    return result != 0 ? result : a.uri.compareTo(b.uri);
  });
  SplayTreeSet<Track> autoplayTracks =
      SplayTreeSet<Track>((final Track a, final Track b) {
    final int currentTime = Timestamp.now().seconds;

    final int aPlayedTimeDiff =
        min(150, (currentTime - (a.lastPlayedTimestamp?.seconds ?? 0)) ~/ 3600);
    final int aSkippedTimeDiff = min(
        150, (currentTime - (a.lastSkippedTimestamp?.seconds ?? 0)) ~/ 3600);
    final int aScore = a.playCount * 2 -
        a.skipCount * 6 +
        aPlayedTimeDiff +
        aSkippedTimeDiff * 2;

    final int bPlayedTimeDiff =
        min(150, (currentTime - (b.lastPlayedTimestamp?.seconds ?? 0)) ~/ 3600);
    final int bSkippedTimeDiff = min(
        150, (currentTime - (b.lastSkippedTimestamp?.seconds ?? 0)) ~/ 3600);
    final int bScore = b.playCount * 2 -
        b.skipCount * 6 +
        bPlayedTimeDiff +
        bSkippedTimeDiff * 2;

    int result = bScore.compareTo(aScore);
    return result != 0 ? result : a.uri.compareTo(b.uri);
  });

  MediaLibraryService() {
    database = () async {
      Directory directory = await getApplicationSupportDirectory();
      await directory.create(recursive: true);
      Database db = await databaseFactoryIo
          .openDatabase(join(directory.path, 'database.db'));
      return db;
    }();
    () async {
      Database db = await database;

      var fileMaps = await fileStore.find(db);

      for (var fileMap in fileMaps) {
        Track track = Track(
          uri: fileMap.key,
          title: fileMap.key.split('/').last,
          artist: null,
          album: null,
          trackNumber: null,
          playCount: fileMap.value['playCount'] as int,
          skipCount: fileMap.value['skipCount'] as int,
          lastPlayedTimestamp:
              fileMap.value['lastPlayedTimestamp'] as Timestamp?,
          lastSkippedTimestamp:
              fileMap.value['lastSkippedTimestamp'] as Timestamp?,
          lyrics: null,
          artwork: null,
        );

        try {
          await readTagFromUri(track, fileMap.key);
        } on FileSystemException {
          fileStore.record(fileMap.key).delete(db);
          continue;
        }

        await syncStores(track);
        allTracks.add(track);
      }
      notifyListeners();
      print("Initialization completed. ${allTracks.length} tracks loaded.");
    }();
  }

  @override
  void dispose() {
    increasePlayCountSubscription?.cancel();
    super.dispose();
  }

  void update(final AudioPlayerService audioPlayerService) {
    print("MediaLibraryService updated");
    final AudioPlayer audioPlayer = audioPlayerService.audioPlayer;
    increasePlayCountSubscription?.cancel();
    increasePlayCountSubscription =
        audioPlayer.positionStream.listen((position) {
      if (audioPlayer.duration != null &&
          position > audioPlayer.duration! ~/ 5 &&
          audioPlayer.playing &&
          audioPlayerService.currentTrack != null &&
          (audioPlayerService.currentTrack!.lastPlayedTimestamp?.compareTo(
                      Timestamp.fromDateTime(
                          DateTime.now().subtract(audioPlayer.duration!))) ??
                  0) <
              5) {
        print(
            "$position :: ${audioPlayer.position} :: ${audioPlayer.duration} :: ${audioPlayerService.currentTrack?.lastPlayedTimestamp} :: ${Timestamp.fromDateTime(DateTime.now().subtract(audioPlayer.duration!))}");
        increasePlayCount(audioPlayerService.currentTrack!);
      }
    });
  }

  Future<void> addTrackByUri(final String uri) async {
    Database db = await database;

    if (await fileStore.record(uri).exists(db)) {
      print("addTrackByUri: uri already exists in fileStore");
      return;
    }

    if (allTracks.contains(Track(uri: uri))) {
      print("addTrackByUri: uri already exists in allTracks");
      return;
    }

    Track track = Track(
      uri: uri,
      title: uri.split('/').last,
      artist: null,
      album: null,
      trackNumber: null,
      playCount: 0,
      skipCount: 0,
      lastPlayedTimestamp: null,
      lastSkippedTimestamp: null,
      lyrics: null,
      artwork: null,
    );

    try {
      await readTagFromUri(track, uri);
    } on FileSystemException {
      print("readTagFromUri(): File not found at $uri");
      return;
    } catch (e) {
      print("Unable to read id3 tag: $e");
    }

    await fileStore.record(uri).add(db, track.toFileMap());
    await syncStores(track);
    allTracks.add(track);
    notifyListeners();
  }

  Future<void> readTagFromUri(final Track track, final String uri) async {
    if (uri.endsWith('.flac')) {
      FlacInfo flacInfo = FlacInfo(File(uri.split("://").last));
      List<Metadata> metadatas = await flacInfo.readMetadatas();
      Map<String, String> flacTag = <String, String>{};

      for (Metadata metadata in metadatas) {
        if (metadata is VorbisComment) {
          for (String element in metadata.comments) {
            flacTag[element.substring(0, element.indexOf('='))] =
                element.substring(element.indexOf('=') + 1);
          }
        } else if (metadata is Picture) {
          track.artwork = metadata.image;
        }
      }

      track.title = flacTag['Title'] ?? track.title;
      track.artist = flacTag['Artist'];
      track.album = flacTag['Album'];
      track.trackNumber = flacTag['TRACKNUMBER'];
      track.lyrics = flacTag['Lyrics'];
    } else {
      id3tag.ID3Tag tag =
          id3tag.ID3TagReader.path(uri.split("://").last).readTagSync();

      track.title = tag.title ?? track.title;
      track.artist = tag.artist;
      track.album = tag.album;
      track.trackNumber = tag.track;
      track.lyrics = tag.lyrics;
      if (tag.pictures.isNotEmpty) {
        track.artwork = Uint8List.fromList(tag.pictures.first.imageData);
      }
    }
  }

  Future<void> syncStores(final Track track) async {
    Database db = await database;

    if (track.isTrackInfoAvailable()) {
      var trackMap = await findTrackMap(track);

      if (trackMap == null) {
        await trackStore.add(db, track.toTrackMap());
      } else {
        track.playCount = trackMap.value['playCount'] as int;
        track.skipCount = trackMap.value['skipCount'] as int;
        track.lastPlayedTimestamp =
            trackMap.value['lastPlayedTimestamp'] as Timestamp?;
        track.lastSkippedTimestamp =
            trackMap.value['lastSkippedTimestamp'] as Timestamp?;
        await fileStore.record(track.uri).update(db, track.toFileMap());
      }
    }
  }

  Future<void> increasePlayCount(final Track track) async {
    Database db = await database;

    RecordSnapshot<int, Map<String, Object?>>? trackMap;

    if (track.isTrackInfoAvailable()) {
      trackMap = await findTrackMap(track);
    }

    track.lastPlayedTimestamp = Timestamp.now();
    if (trackMap == null) {
      ++track.playCount;
    } else {
      track.playCount = (trackMap.value['playCount'] as int) + 1;
      track.skipCount = trackMap.value['skipCount'] as int;
      track.lastSkippedTimestamp =
          trackMap.value['lastSkippedTimestamp'] as Timestamp?;

      await trackStore.record(trackMap.key).update(db, track.toTrackMap());
    }
    await fileStore.record(track.uri).update(db, track.toFileMap());
  }

  Future<void> increaseSkipCount(final Track track) async {
    Database db = await database;

    RecordSnapshot<int, Map<String, Object?>>? trackMap;

    if (track.isTrackInfoAvailable()) {
      trackMap = await findTrackMap(track);
    }

    track.lastSkippedTimestamp = Timestamp.now();
    if (trackMap == null) {
      ++track.skipCount;
    } else {
      track.playCount = trackMap.value['playCount'] as int;
      track.skipCount = (trackMap.value['skipCount'] as int) + 1;
      track.lastPlayedTimestamp =
          trackMap.value['lastPlayedTimestamp'] as Timestamp?;

      await trackStore.record(trackMap.key).update(db, track.toTrackMap());
    }
    await fileStore.record(track.uri).update(db, track.toFileMap());
  }

  void generateAutoplayTracks() {
    autoplayTracks.clear();
    autoplayTracks.addAll(allTracks);
    notifyListeners();
  }

  Future<RecordSnapshot<int, Map<String, Object?>>?> findTrackMap(
      final Track track) async {
    Database db = await database;

    return trackStore.findFirst(
      db,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('title', track.title),
          Filter.equals('artist', track.artist),
          Filter.equals('album', track.album),
          Filter.equals('trackNumber', track.trackNumber),
        ]),
      ),
    );
  }
}
