import 'package:on_audio_query/on_audio_query.dart';
import '../models/song.dart';

class MusicService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  
  Future<List<Song>> getAllSongs() async {
    try {
      List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
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

  Future<List<Song>> getAlbums() async {
    try {
      List<AlbumModel> albums = await _audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
      );
      List<Song> albumSongs = [];
      for (var album in albums) {
        List<SongModel> songs = await _audioQuery.queryAudiosFrom(
          AudiosFromType.ALBUM_ID,
          album.id,
        );
        albumSongs.addAll(songs.map((s) => Song(
          id: s.id.toString(),
          title: s.displayNameWOExt,
          artist: s.artist ?? 'Unknown',
          album: album.album,
          path: s.data,
          duration: Duration(milliseconds: s.duration ?? 0),
          size: s.size,
        )));
      }
      return albumSongs;
    } catch (e) {
      return [];
    }
  }

  Future<List<Song>> getArtists() async {
    try {
      List<ArtistModel> artists = await _audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
      );
      List<Song> artistSongs = [];
      for (var artist in artists) {
        List<SongModel> songs = await _audioQuery.queryAudiosFrom(
          AudiosFromType.ARTIST_ID,
          artist.id,
        );
        artistSongs.addAll(songs.map((s) => Song(
          id: s.id.toString(),
          title: s.displayNameWOExt,
          artist: artist.artist,
          album: s.album ?? 'Unknown',
          path: s.data,
          duration: Duration(milliseconds: s.duration ?? 0),
          size: s.size,
        )));
      }
      return artistSongs;
    } catch (e) {
      return [];
    }
  }
}
