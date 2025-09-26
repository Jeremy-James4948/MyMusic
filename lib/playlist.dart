import 'package:flutter/material.dart';

class Song {
  final String title;
  final String artist;
  final String albumArtUrl;

  const Song({required this.title, required this.artist, required this.albumArtUrl});
}

class Playlist extends StatelessWidget {
  final List<Song> songs;

  const Playlist({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The 🔥🔥 Vibe Playlist'),
        backgroundColor: const Color(0xFF1DB954),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: Image.network(
              song.albumArtUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              
            },
          );
        },
      ),
    );
  }
}