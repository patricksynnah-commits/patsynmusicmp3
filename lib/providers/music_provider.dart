import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _musicService = MusicService();
  final AudioPlayer _player = AudioPlayer();
  
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int _currentIndex = 0;
  bool _isShuffled = false;
  bool _isRepeat = false;

  List<Song> get allSongs => _allSongs;
  List<Song> get filteredSongs => _filteredSongs;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  AudioPlayer get player => _player;
  bool get isShuffled => _isShuffled;
  bool get isRepeat => _isRepeat;

  MusicProvider() {
    loadSongs();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _player.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
    
    _player.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });
    
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeat) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          playNext();
        }
      }
    });
  }

  Future<void> loadSongs() async {
    _allSongs = await _musicService.getAllSongs();
    _filteredSongs = _allSongs;
    notifyListeners();
  }

  void searchSongs(String query) {
    if (query.isEmpty) {
      _filteredSongs = _allSongs;
    } else {
      _filteredSongs = _allSongs.where((song) =>
        song.title.toLowerCase().contains(query.toLowerCase()) ||
        song.artist.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _filteredSongs.length) return;
    _currentIndex = index;
    _currentSong = _filteredSongs[index];
    await _player.setAudioSource(AudioSource.file(_currentSong!.path));
    await _player.play();
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (_filteredSongs.isEmpty) return;
    int nextIndex;
    if (_isShuffled) {
      nextIndex = DateTime.now().millisecond % _filteredSongs.length;
    } else {
      nextIndex = (_currentIndex + 1) % _filteredSongs.length;
    }
    await playSong(nextIndex);
  }

  Future<void> playPrevious() async {
    if (_filteredSongs.isEmpty) return;
    if (_currentPosition.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else {
      int prevIndex = (_currentIndex - 1 + _filteredSongs.length) % _filteredSongs.length;
      await playSong(prevIndex);
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }
}
