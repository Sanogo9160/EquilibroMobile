import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_player_widget.dart';
import 'youtube_player_widget.dart'; 

class VideoManagerWidget extends StatelessWidget {
  final String videoUrl;

  VideoManagerWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // Vérifie si l'URL est une vidéo YouTube
    final isYoutube = YoutubePlayer.convertUrlToId(videoUrl) != null;

    // Si c'est une vidéo YouTube, affiche le lecteur YouTube
    if (isYoutube) {
      return YoutubePlayerWidget(videoUrl: videoUrl);
    } else {
      // Sinon, affiche le lecteur VideoPlayer pour MP4 ou autres formats
      return VideoPlayerWidget(videoUrl: videoUrl);
    }
  }
}
