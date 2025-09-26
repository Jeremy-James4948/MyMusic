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
    final _focusNode = FocusNode();

    @override
    void dispose() {
      _mood.dispose();
      _focusNode.dispose();
      super.dispose();
    }

    void _genplaylist() async {
      final mood = _mood.text.trim();
      if (mood.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a mood to generate your playlist.')),
          );
        }
        return;
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1DB954)),
          ),
        );
      }

      try {
        final generatePlaylist = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('generatePlaylist');
        final result = await generatePlaylist.call({'mood': mood});

        final List<dynamic> trackData = result.data;
        final songs = trackData.map((data) => Song(
          title: data['title'],
          artist: data['artist'],
          albumArtUrl: data['albumArtUrl'] ?? 'https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304', 
        )).toList();

        if (mounted) {
          Navigator.of(context).pop(); 
        }

        if (mounted && songs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No songs found for this mood. Try another!')),
          );
          return;
        }
        
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Playlist(songs: songs),
            ),
          );
        }

      } on FirebaseFunctionsException catch (error) {
        if (mounted) {
          Navigator.of(context).pop(); 
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error.message}')),
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.of(context).pop(); 
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong. Please try again.')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF121212),
                  Color(0xFF1a1a1a),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 64,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  const SizedBox(height: 24),
                const Text(
                  "What's Your Vibe rn!?🎵🤪",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                  const SizedBox(height: 16),
                  Text(
                    'Let me create that flow which is missing 😜🤭',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _mood,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.music_note_rounded, color: Color(0xFF1DB954)),
                      labelText: 'e.g., "a late night drive with friends 🔥🔥"',
                      filled: true,
                      fillColor: const Color(0xFF2a2a2a),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1DB954), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red[400]!, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_) => _genplaylist(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome, color: Colors.black),
                    label: const Text(
                      'LET IT RIP!!🔥🤘🎶🎸',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                      onPressed: _genplaylist,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        elevation: 8,
                        shadowColor: const Color(0xFF1DB954).withValues(alpha: 0.3),
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
        ),
      );
    }
  }
