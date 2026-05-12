import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patsyn Music'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search songs...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1DB954)),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<MusicProvider>().searchSongs(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<MusicProvider>(
              builder: (context, provider, child) {
                if (provider.filteredSongs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No songs found', style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: provider.filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = provider.filteredSongs[index];
                    final isCurrentSong = provider.currentSong?.id == song.id;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCurrentSong ? const Color(0xFF1DB954) : const Color(0xFF2A2A2A),
                        child: Icon(isCurrentSong ? Icons.play_arrow : Icons.music_note, color: Colors.white),
                      ),
                      title: Text(song.title, style: TextStyle(color: isCurrentSong ? const Color(0xFF1DB954) : Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: Text('${song.artist} • ${song.album}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      trailing: Text(_formatDuration(song.duration), style: TextStyle(color: Colors.grey[400])),
                      onTap: () {
                        provider.playSong(index);
                        Navigator.pushNamed(context, '/player');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
