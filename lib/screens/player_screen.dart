import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
      ),
      body: Consumer<MusicProvider>(
        builder: (context, provider, child) {
          if (provider.currentSong == null) {
            return const Center(child: Text('No song selected', style: TextStyle(color: Colors.grey)));
          }
          final song = provider.currentSong!;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A1A), Color(0xFF121212)],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    width: 280, height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2A2A2A),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF1DB954).withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
                      ],
                    ),
                    child: Icon(Icons.music_note, size: 120, color: provider.isPlaying ? const Color(0xFF1DB954) : Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(song.artist, style: TextStyle(fontSize: 18, color: Colors.grey[300])),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(provider.currentPosition), style: TextStyle(color: Colors.grey[400])),
                            Text(_formatDuration(provider.totalDuration), style: TextStyle(color: Colors.grey[400])),
                          ],
                        ),
                        Slider(
                          activeColor: const Color(0xFF1DB954),
                          inactiveColor: Colors.grey[800],
                          value: provider.currentPosition.inSeconds.toDouble(),
                          max: provider.totalDuration.inSeconds.toDouble() == 0 ? 1 : provider.totalDuration.inSeconds.toDouble(),
                          onChanged: (value) {
                            provider.seekTo(Duration(seconds: value.toInt()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: provider.isShuffled ? const Color(0xFF1DB954) : Colors.white, size: 30),
                        onPressed: () => provider.toggleShuffle(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        onPressed: () => provider.playPrevious(),
                      ),
                      Container(
                        width: 70, height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1DB954),
                        ),
                        child: IconButton(
                          icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                          onPressed: () => provider.togglePlayPause(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                        onPressed: () => provider.playNext(),
                      ),
                      IconButton(
                        icon: Icon(Icons.repeat, color: provider.isRepeat ? const Color(0xFF1DB954) : Colors.white, size: 30),
                        onPressed: () => provider.toggleRepeat(),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
