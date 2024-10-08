import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoListScreen extends StatefulWidget {
  final List<Video> videos;

  const VideoListScreen({
    Key? key,
    required this.videos,
  }) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late AudioPlayer _player;
  bool isPlaying = false;
  int currentIndex = 0;
  late List<bool> isPlayingList;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

 late List<Duration>positionlist;

  final yt = YoutubeExplode();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    isPlayingList = List.generate(widget.videos.length, (index) => false);
     positionlist = List.generate(widget.videos.length, (index) => Duration.zero);


  
  }

  void audioplay(VideoId videoid) async {
// isPlayingList = List.generate(widget.videos.length, (index) => false);
    final streamManifest = await yt.videos.streamsClient.getManifest(videoid);
    final audioStreams = streamManifest.audioOnly;

    final audioStreamInfo = audioStreams.first;

 if (positionlist[currentIndex].inSeconds ==Duration.zero) {
      playAudioFromUrl(audioStreamInfo.url.toString());
      _player.setVolume(1);
    } else {
      _player.resume();
    }

   

    //  final video = await yt.videos.get(videourl);
  }

  void playAudioFromUrl(String audioUrl) async {
    await _player.setSourceUrl(audioUrl);
    _player.play(UrlSource(audioUrl));
    _player.onPlayerComplete.listen((event) {
      if (currentIndex < widget.videos.length - 1) {
        setState(() {
          isPlayingList[currentIndex] = !isPlayingList[currentIndex];
          isPlayingList[currentIndex + 1] = !isPlayingList[currentIndex + 1];
        });
        currentIndex++;
        audioplay(widget.videos[currentIndex].id);
      }
    });

        _player.onPositionChanged.listen((position) {
      // if (mounted) {
      //   setState(() {
      //     _position = position;
      //   });
      // }

      setState(() {
        _position = position;
        positionlist[currentIndex]=position;
        print(position);
      });
    });
    _player.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

      _player.onDurationChanged.listen((duration) {
      // if (mounted) {
      //   setState(() {
      //     _duration = duration;
      //   });
      // }

      setState(() {
        _duration = duration;
        print(duration);
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            
            SizedBox(
              width:  MediaQuery.sizeOf(context).width * 0.91,
              child: ListView.builder(
                // padding: const EdgeInsetsDirectional.symmetric(vertical: 2),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.videos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.deepPurple[200],
                    child: InkWell(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50.0), bottom: Radius.circular(50.0)),
                        splashColor: Colors.pink,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(widget.videos[index].title,style: TextStyle(fontSize: 16.0)),
                            ),
                            Row(
                              children: [
                                 Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              ("${widget.videos[index].duration}"),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                            Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              positionlist[index].toString().substring(0, 7),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:  MediaQuery.sizeOf(context).width * 0.07,
                                ),
                                IconButton(
                                  icon: Icon(Icons.replay_30_sharp),
                  
                                  onPressed: () {
                                    _player.seek(_position - Duration(seconds: 30));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.replay_10),
                                  onPressed: () {
                                    _player.seek(_position - Duration(seconds: 10));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(isPlayingList[index]
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: () {
                                    // Play the video
                                    // audioplay(widget.videos);
                                    if (isPlayingList[index]) {
                                      _player.pause();
                                    } else {
                                      audioplay(widget.videos[index].id);
                                    }
                                    setState(() {
                                      isPlayingList[index] = !isPlayingList[index];
                                    });
                                  },
                                ),
                              
                                IconButton(
                                  icon: Icon(Icons.forward_10_rounded),
                                  onPressed: () {
                                    _player.seek(_position + Duration(seconds: 10));
                                  },
                                ),
                                  IconButton(
                                  icon: Icon(Icons.forward_30_rounded),
                                  onPressed: () {
                                    _player.seek(_position + Duration(seconds: 30));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* ListTile(
              title: Text(widget.videos[index].title),
              trailing: IconButton(
                icon: Icon(isPlayingList[index] ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  // Play the video
                  // audioplay(widget.videos);
                  if (isPlayingList[index]) {
                    _player.pause();
                  } else {
                    audioplay(widget.videos[index].id);
                  }
                  setState(() {
                    isPlayingList[index] = !isPlayingList[index];
                  });
                },
              ),
            ), */