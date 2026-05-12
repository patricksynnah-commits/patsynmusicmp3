import 'package:on_audio_query/on_audio_query.dart';
import '../models/song.dart';

class MusicService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  
  Future<List<Song>> getAllSongs() async {
    try {
      List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        uriType: UriType.EXTERNAL,
      );
      return songs.map((s) => Song(
        id: s.id.toString(),
        title: s.displayNameWOExt,
        artist: s.artist ?? 'Unknown Artist',
        album: s.album ?? 'Unknown Album',
        path: s.data,
        duration: Duration(milliseconds: s.duration ?? 0),
        size: s.size,
      )).toList();
    } catch (e) {
      return [];
    }
  }
}
