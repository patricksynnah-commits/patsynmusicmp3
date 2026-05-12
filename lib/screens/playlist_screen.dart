import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
        centerTitle: true,
      ),
      body: Consumer<MusicProvider>(
        builder: (context, provider, child) {
          if (provider.allSongs.isEmpty) {
            return const Center(child: Text('No songs found', style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            itemCount: provider.allSongs.length,
            itemBuilder: (context, index) {
              final song = provider.allSongs[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2A2A2A),
                  child: Icon(Icons.music_note, color: Colors.white),
                ),
                title: Text(song.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(song.artist, style: TextStyle(color: Colors.grey[400])),
                trailing: IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: Color(0xFF1DB954)),
                  onPressed: () {
                    provider.playSong(index);
                    Navigator.pushNamed(context, '/player');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
