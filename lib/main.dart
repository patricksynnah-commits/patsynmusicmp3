import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/player_screen.dart';
import 'screens/playlist_screen.dart';
import 'providers/music_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  await Permission.audio.request();
  runApp(
    ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: const PatsynMusicApp(),
    ),
  );
}

class PatsynMusicApp extends StatelessWidget {
  const PatsynMusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patsyn Music MP3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1DB954),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFF1DB954),
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/player': (context) => const PlayerScreen(),
        '/playlist': (context) => const PlaylistScreen(),
      },
    );
  }
}
