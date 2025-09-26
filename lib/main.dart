  import 'package:flutter/material.dart';
  import 'dart:async';
  import 'playlist.dart';
  import 'package:cloud_functions/cloud_functions.dart';

  import 'package:firebase_core/firebase_core.dart';
  import 'firebase_options.dart'; 

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized(); 
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp()); 
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'VibeTune',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1DB954),
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const HomeScreen(),
      );
    }
  }

  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final _mood = TextEditingController();

    @override
    void dispose() {
      _mood.dispose();
      super.dispose();
    }

    void _genplaylist() async {
    final mood = _mood.text;
    if (mood.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final generatePlaylist = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('generatePlaylist');
      final result = await generatePlaylist.call({'mood': mood});

      final List<dynamic> trackData = result.data;
      final songs = trackData.map((data) => Song(
        title: data['title'],
        artist: data['artist'],
        albumArtUrl: data['albumArtUrl'] ?? 'https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304', 
      )).toList();

      Navigator.of(context).pop(); 

      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Playlist(songs: songs),
        ),
      );

    } on FirebaseFunctionsException catch (error) {
      Navigator.of(context).pop(); 
      
      print(error.message);
    }
  }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Summon a Soundscape.",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Translate your emotions into music. Let our AI be your DJ.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _mood,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.music_note_rounded),
                    labelText: 'e.g., "a walk through a cyberpunk city"',
                    filled: true,
                    fillColor: const Color(0xFF2a2a2a),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _genplaylist(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome, color: Colors.black),
                    label: const Text(
                      'REVEAL MY MIX',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: _genplaylist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
