import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:filmy/DrawerMenu.dart';
import 'package:filmy/video_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoModel> videos = [];

  @override
  void initState() {
    super.initState();

    fetchVideos().then((videos) {
      setState(() {
        this.videos = videos;
      });
    });

    Timer.periodic(const Duration(seconds: 1800), (timer) {
      fetchVideos().then((videos) {
        print(videos);
        setState(() {
          this.videos = videos;
        });
      });
    });
  }

  Future<List<VideoModel>> fetchVideos() async {
    // Get the video data from the HTTP server.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var server_url = prefs.getString("server_url");

    if (server_url != null && server_url.length > 2) {
      try {
        var url = Uri.parse(server_url);
        var response = await http.get(url);
        var videos = (json.decode(response.body) as List)
            .map((video) => VideoModel.fromJson(video))
            .toList();
        return videos;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Error : " + e.toString()),
        ));
      }
    }

    // Parse the JSON response into a list of VideoModel objects.

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        drawer: const DrawerMenu(),
        appBar: AppBar(
          title: const Text('Filmy'),
        ),
        body: videos.length > 0
            ? GridView.builder(
                itemCount: videos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 16 / 9,
                ),
                itemBuilder: (context, index) {
                  var coverImage = videos[index].coverImage;
                  var isCoverImageAvailable = true;
                  if (coverImage == null || coverImage.length == 0) {
                    isCoverImageAvailable = false;
                  }
                  return InkWell(
                      focusColor: Colors.white,
                      onTap: () {
                        final intent = AndroidIntent(
                            //package: 'com.brouken.player',
                            //type: MIME.applicationXMpegURL,
                            action: 'action_view',
                            data: Uri.parse(videos[index].url).toString(),
                            flags: <int>[
                              Flag.FLAG_ACTIVITY_NEW_TASK,
                              Flag.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                            ]);
                        intent.launch();
                      },
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Card(
                          color: Colors.black12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: isCoverImageAvailable
                                    ? Image.network(videos[index].coverImage,
                                        fit: BoxFit.cover)
                                    : Text(videos[index].title),
                              ),
                              const Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(videos[index].title,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ));

                  /*return ListTile(

            title: Text(videos[index].title),
            //subtitle: Text(videos[index].url),
            leading: Image.network(videos[index].coverImage),
            onTap: () {
              // Play the video.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(video: videos[index]),
                ),
              );
            },
          );*/
                },
              )
            : Container(
                child: const Align(
                child: Text("Please check server url or add server url"),
                alignment: Alignment.center,
              )));
  }
}
