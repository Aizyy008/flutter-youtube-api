import "package:flutter/material.dart";
import "package:youtube_api/model/playlist_model.dart";
import "package:youtube_player_flutter/youtube_player_flutter.dart";

class VideoPlayerScreen extends StatefulWidget {
  final VideoItems? videoItem;
  VideoPlayerScreen({super.key, required this.videoItem});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController youtubePlayerController;
  late bool isPlayerReady;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPlayerReady = false;
    youtubePlayerController = YoutubePlayerController(initialVideoId: widget.videoItem!.id.toString(),
    flags: YoutubePlayerFlags(
      mute: false,
      autoPlay: true,

    )
    )..addListener(listener);
  }

  void listener(){
    if(isPlayerReady && mounted && !youtubePlayerController.value.isFullScreen){

    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    youtubePlayerController.pause();
    super.deactivate();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    youtubePlayerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoItem!.snippet!.title.toString()),
        centerTitle: true,
      ),
      body: Container(
        child: YoutubePlayer(
          controller: youtubePlayerController,
          showVideoProgressIndicator: true,
            onReady: (){
              isPlayerReady: true;
            print("PLAYER IS READY");

            },
        ),
      ),
    );
  }
}
