import 'package:flutter/material.dart';

class Song {
  final String title;
  final String artist;
  final String albumArtUrl;

  const Song({required this.title, required this.artist, required this.albumArtUrl});
}

class Playlist extends StatefulWidget {
  final List<Song> songs;

  const Playlist({super.key, required this.songs});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  int? _playingIndex;

  void _togglePlay(int index) {
    setState(() {
      if (_playingIndex == index) {
        _playingIndex = null;
      } else {
        _playingIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.songs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Playlist'),
          backgroundColor: const Color(0xFF1DB954),
          foregroundColor: Colors.black,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.playlist_add, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No songs found for this vibe.',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Try a different mood!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vibe Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1DB954),
        foregroundColor: Colors.black,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          final song = widget.songs[index];
          final isPlaying = _playingIndex == index;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _togglePlay(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        song.albumArtUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.music_note, color: Colors.grey),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2a2a2a),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: isPlaying ? const Color(0xFF1DB954) : Colors.grey,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
