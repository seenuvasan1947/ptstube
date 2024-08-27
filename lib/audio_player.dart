// import 'dart:js_interop';

import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'modules.dart';

class audplayer extends StatefulWidget {
  
  audplayer({super.key, });
  @override
  _audplayerState createState() => _audplayerState();
}

class _audplayerState extends State<audplayer> {
  late AudioPlayer _player;

  // String _url = "https://samplelib.com/lib/preview/mp3/sample-15s.mp3";
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
TextEditingController srcvidurl =TextEditingController();
TextEditingController srcplaylisturl =TextEditingController();

  bool hasPermission =false;
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPositionChanged.listen((position) {
      // if (mounted) {
      //   setState(() {
      //     _position = position;
      //   });
      // }

      setState(() {
        _position = position;
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
      });
    });
    // setplayerstate();
  }

  @override
  void dispose() {
    super.dispose();
    _player.stop();
  }

  void audioplay() async {
    final videoUrl = srcvidurl.text;
    final audioUrl = await getAudioStreamUrl(videoUrl);

    if (_duration.inSeconds == 0.0) {
      playAudioFromUrl(audioUrl);
      _player.setVolume(1);
    } else {
      _player.resume();
    }
  }

  Future<String> getAudioStreamUrl(String videoUrl) async {
    final yt = YoutubeExplode();
    final video = await yt.videos.get(videoUrl);
    // print('1111');
    // print(video);
    // print('========');
    final streamManifest = await yt.videos.streamsClient.getManifest(video.id);
    // final strm=await yt.videos.closedCaptions.getManifest(videoUrl);

    // final strtam= strm.getByLanguage('en');

    // var tamtam=yt.videos.closedCaptions.get(strtam[0]);
    // print('22222');
    // // print(strtam);
    // print('33333');
    // // print(tamtam);
    // print('44444');
    // print(streamManifest);
    // print('========');
    final audioStreams = streamManifest.audioOnly;
    // print(audioStreams);
    // print('========');
    final audioStreamInfo = audioStreams.first;
    // print(audioStreamInfo);
    // print('========');
    // print(audioStreamInfo.url);

    yt.close();

    return audioStreamInfo.url.toString();
  }

  void playAudioFromUrl(String audioUrl) async {
    await _player.setSourceUrl(audioUrl);
    _player.play(UrlSource(audioUrl));
    isPlaying = true;
  }

//   void setplayerstate() async{
// int count=0;
// if(count==0){
//     final prefs = await SharedPreferences.getInstance();
//               // await prefs.setBool('isPlaying', isPlaying);
//               bool? isPlay = await prefs.getBool('isPlaying');
//               print('***676****');
//               print(isPlay);
//               isPlaying=isPlay! as bool;
//               print('^^^^^^^^');
//               print(isPlaying);
//               count=count+1;
//                }
//               count=0;
//   }



// void playlistviddownload(playlisturl)async{
//  var videoTitle='';
// var yt = YoutubeExplode();
// int count =0;
// var file=File('');
// // Get playlist metadata.
// var playlist = await yt.playlists.get(playlisturl);

// var title = playlist.title;
// var author = playlist.author;

//   Fluttertoast.showToast(
//         msg: 'you audio downloading please wait',
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: const Color.fromARGB(255, 109, 96, 169),
//         textColor: const Color.fromARGB(255, 15, 0, 0),
//         gravity: ToastGravity.CENTER,
//         fontSize: 20.0,
//       );
//   await for (var video in yt.playlists.getVideos(playlist.id)) {
//    videoTitle = video.title;
//     var videoAuthor = video.author;




// final streamManifest = await yt.videos.streamsClient.getManifest(video.id);

// // final streamInfo = streamManifest.muxed.bestQuality;
// final streamInfo =streamManifest.audio.withHighestBitrate();

// // if (streamInfo != null) {
//   // Get the actual stream
//   var stream = yt.videos.streamsClient.get(streamInfo);
  
// final permissionStatus = await Permission.storage.status;
// if(permissionStatus.isDenied){

// // final status = await Permission.manageExternalStorage.request();
// final status = await Permission.storage.request();
//     setState(() {
//       hasPermission = status.isGranted;
//     });
// }    
// else{
//   hasPermission=permissionStatus.isGranted;
// }













//  if (await Permission.storage.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.

      


//       // Directory? dir = await getExternalStorageDirectory();

//   Directory filedir = Directory('/storage/emulated/0/ptstube');
//         if (!(await filedir.exists())) {
//           await filedir.create(recursive: true);
//           print('Directory created at $filedir');
//         } else {
//           print('Directory already exists at $filedir');
//         }








//   // Open a file for writing.
// try {
//    file = File(path.join('${filedir.path}','${video.title.toString()}.mp3'));
//  await file.create();
// } catch (e) {

//     file = File(path.join('${filedir.path}','${video.id.toString()}.mp3'));
//  await file.create();
  
// }
 

//     Fluttertoast.showToast(
//         msg: '$file started',
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: const Color.fromARGB(255, 109, 96, 169),
//         textColor: const Color.fromARGB(255, 15, 0, 0),
//         gravity: ToastGravity.CENTER,
//         fontSize: 20.0,
//       );
//   var fileStream = file.openWrite();

//   // Pipe all the content of the stream into the file.
//   await stream.pipe(fileStream);

//       Fluttertoast.showToast(
//         msg: '$file downloded',
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: const Color.fromARGB(255, 109, 96, 169),
//         textColor: const Color.fromARGB(255, 15, 0, 0),
//         gravity: ToastGravity.CENTER,
//         fontSize: 20.0,
//       );
//       count=count+1;
//   // Close the file.
//   await fileStream.flush();
//   await fileStream.close();
  

//  }
//  if(count==yt.playlists.getVideos(playlist.id).length){
//      Fluttertoast.showToast(
//         msg: 'all files are  downloded',
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: const Color.fromARGB(255, 109, 96, 169),
//         textColor: const Color.fromARGB(255, 15, 0, 0),
//         gravity: ToastGravity.CENTER,
//         fontSize: 20.0,
//       );
//   }
//   }

// // var playlistVideos = await yt.playlists.getVideos(playlist.id);

// // Get first 20 playlist videos.
// // var somePlaylistVideos = await yt.playlists.getVideos(playlist.id).take(20);

// }



  @override
  Widget build(BuildContext context) {
    // bool isPlaying = false;
    // setplayerstate();
    // print('sample');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("book name"),
          leading: IconButton(
              onPressed: () {
                _player.stop();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_rounded)),
        ),
        body: Center(
          child: Column(
            children: [
               TextField(
                controller: srcvidurl,
                decoration: InputDecoration(
                  labelText: 'video url',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ProgressBar(
                  progress: Duration(seconds: _position.inSeconds),
                  buffered: Duration(seconds: _position.inSeconds + 15),
                  total: Duration(seconds: _duration.inSeconds),
                  onSeek: (duration) {
                    print('User selected a new time: $duration');
                    print(isPlaying);
                    _player.seek(Duration(seconds: duration.inSeconds));
                  },
                  timeLabelType: TimeLabelType.remainingTime,
                  barCapShape: BarCapShape.round,
                  barHeight: 10,
                  progressBarColor: Colors.purple[200],
                  bufferedBarColor: Colors.green[200],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    onPressed: () {
                      _player.seek(_position - Duration(seconds: 10));
                    },
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        _player.pause();
                      } else {
                        audioplay();
                      }

                      // setplayerstate();
                      //         if (mounted) {
                      //           setState(() {
                      //             isPlaying = !isPlaying;
                      //           });
                      //           final prefs = await SharedPreferences.getInstance();
                      // await prefs.setBool('isPlaying', isPlaying);
                      // bool? crnt= await prefs.getBool('isPlaying');
                      // print('*********');
                      // isPlaying=crnt!;
                      // print(crnt);
                      //         }

                      // setState(() {
                      //   isPlaying = !isPlaying;
                      // });
                      //         final prefs = await SharedPreferences.getInstance();
                      // await prefs.setBool('isPlaying', isPlaying);
                      // bool? crnt= await prefs.getBool('isPlaying');
                      // print('*********');
                      // isPlaying=crnt!;
                      // print(crnt);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10_rounded),
                    onPressed: () {
                      _player.seek(_position + Duration(seconds: 10));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _duration.toString().substring(0, 7),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.20,),
               TextField(
                controller: srcplaylisturl,
                decoration: InputDecoration(
                  labelText: 'playlist url',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              ElevatedButton(onPressed: (){
playlistviddownload(srcplaylisturl,PlaylistContentType.audio,'mp3','Music');
              }, child: Text('Download'))
            ],
          ),
        ),
      ),
    );
  }
}