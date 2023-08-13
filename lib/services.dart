import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:youtube_api/constants.dart';
import 'package:youtube_api/model/channel_model.dart';
import 'package:youtube_api/model/playlist_model.dart';

class Services{

  static const CHANNEL_ID = "UCzvRaprYPhvAplMK36Gu0kw";
  static const baseURL = "youtube.googleapis.com";

  /*curl \
  'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2C%20contentDetails%2C%20statistics&id=UCzvRaprYPhvAplMK36Gu0kw&access_token=AIzaSyDKPkDEgRt2gVwIQspQObcXlHKo91OluuY&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed
*/

static Future<ChannelModel> getChannelInfo() async{

  Map<String, String> parameters = {
     "part":"snippet, contentDetails, statistics",
    "id": CHANNEL_ID,
    "key": Constants.KEY
  };
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json"
  };
  Uri uri = Uri.https(baseURL, "youtube/v3/channels", parameters);
  Response response = await http.get(uri, headers: headers);
  print(response.body);
  ChannelModel channelModel = channelModelFromJson(response.body);
  return channelModel;
}

static Future<PlaylistModel> getVideosInfo({required String pageToken}) async{
  Map<String, String> parameters = {
    "part":"snippet",
    "channelId": CHANNEL_ID,
    "key": Constants.KEY,
    "pageToken" : pageToken
  };
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json"
  };
  Uri uri = Uri.https(baseURL, "youtube/v3/playlists", parameters);
  Response response = await http.get(uri, headers: headers);
  print(response.body);
  PlaylistModel playlistModel = playlistModelFromJson(response.body);
  return playlistModel;
}
}