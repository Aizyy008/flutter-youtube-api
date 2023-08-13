import "package:flutter/material.dart";
import 'package:youtube_api/model/channel_model.dart';
import "package:youtube_api/model/playlist_model.dart";
import "package:youtube_api/screens/video_player_screen.dart";
import "package:youtube_api/services.dart";
import "package:cached_network_image/cached_network_image.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube"),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          child:
              BuildView(),
            ),
    );
  }
}

class BuildView extends StatefulWidget {
  const BuildView({super.key});

  @override
  State<BuildView> createState() => _BuildViewState();
}

class _BuildViewState extends State<BuildView> {
  late ChannelModel channelModel;
  Item? item;
  late bool loading;
  String contentDetails = '';
  VideoItems? videos;
  late PlaylistModel playlistModel;
  late String pageToken;
ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChannelInfo();
    playlistModel = PlaylistModel();
    playlistModel.videos = <VideoItems>[];
    pageToken = "";
    loading = true;
  }

  getChannelInfo() async {
    channelModel = await Services.getChannelInfo();
    item = channelModel.items![0];
    await getVideosInfo();
    setState(() {
      loading = false;
    });

  }

  getVideosInfo() async {
    PlaylistModel tempPlayList = await Services.getVideosInfo(pageToken: pageToken);
    pageToken = tempPlayList.nextPageToken.toString();
    playlistModel.videos?.addAll(tempPlayList.videos as Iterable<VideoItems>);
    print("Videos: ${playlistModel.videos}");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
          child: CircularProgressIndicator(
              color: Colors.blue,
            ),
        )
        : Column(
          children: [
            Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          item!.snippet.thumbnails.medium.url.toString(),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          item!.snippet.title.toString(),
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(item!.statistics.videoCount.toString()),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification){
                  if(notification.metrics.pixels == notification.metrics.maxScrollExtent){
                    getVideosInfo();
                  }
                  return true;
                },
                child: ListView.builder(controller: scrollController, itemCount: playlistModel.videos?.length,itemBuilder: (context, index){
                  VideoItems? videoItem = playlistModel.videos![index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      child: Card(
                        color: Colors.grey,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(image: CachedNetworkImageProvider(
videoItem.snippet!.thumbnails!.ddefault!.url.toString()
                              )),
                            ),
                            SizedBox(width: 20,),
                            Flexible(child: Text(videoItem.snippet!.title.toString(),textAlign: TextAlign.center,))
                          ,SizedBox(width: 20,)

                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoItem: videoItem)));
                      },
                    ),
                  );
                }),
              ),
            )
          ],
        );
  }
}
