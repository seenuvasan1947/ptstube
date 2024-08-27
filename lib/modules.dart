



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;


enum PlaylistContentType {
  audio,
  video,
}


void playlistviddownload( playlisturl, contenttype, extensiontype,rootfolderName)async{
 var videoTitle='';
var yt = YoutubeExplode();
int count =0;
var file=File('');
 bool hasPermission =false;
// Get playlist metadata.
var playlist = await yt.playlists.get(playlisturl);

var title = playlist.title;
var author = playlist.author;

  Fluttertoast.showToast(
        msg: 'you $contenttype downloading please wait',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
  await for (var video in yt.playlists.getVideos(playlist.id)) {
   videoTitle = video.title;
    var videoAuthor = video.author;

print(videoAuthor);


final streamManifest = await yt.videos.streamsClient.getManifest(video.id);

/* ^^^^^^^^^^^^^^^^^^^^^^ */
final streamInfo = contenttype==PlaylistContentType.audio? streamManifest.audio.withHighestBitrate():streamManifest.muxed.bestQuality;
// final streamInfo = streamManifest.audio.withHighestBitrate();

// if (streamInfo != null) {
  // Get the actual stream
  var stream = yt.videos.streamsClient.get(streamInfo);
  
final permissionStatus = await Permission.storage.status;
print(permissionStatus);
if(permissionStatus.isDenied){

// final status = await Permission.manageExternalStorage.request();
final status = await Permission.storage.request();
    // setState(() {
    //   hasPermission = status.isGranted;
    // });
  
      hasPermission = status.isGranted;
  
}    
else{
  hasPermission=permissionStatus.isGranted;
}













 if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.

      


      // Directory? dir = await getExternalStorageDirectory();

  Directory filedir = Directory('/storage/emulated/0/$rootfolderName/ptstube/');
        if (!(await filedir.exists())) {
          await filedir.create(recursive: true);
          print('Directory created at $filedir');
        } else {
          print('Directory already exists at $filedir');
        }








  // Open a file for writing.
try {
   file = File(path.join('${filedir.path}','${video.title.toString()}.$extensiontype'));
 await file.create();
} catch (e) {

    file = File(path.join('${filedir.path}','${video.id.toString()}.$extensiontype'));
 await file.create();
  
}
 

    Fluttertoast.showToast(
        msg: '$file started',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
  var fileStream = file.openWrite();

  // Pipe all the content of the stream into the file.
  await stream.pipe(fileStream);

      Fluttertoast.showToast(
        msg: '$file downloded',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
      count=count+1;
  // Close the file.
  await fileStream.flush();
  await fileStream.close();
  

 }
 if(count==yt.playlists.getVideos(playlist.id).length){
     Fluttertoast.showToast(
        msg: 'all files are  downloded',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: const Color.fromARGB(255, 109, 96, 169),
        textColor: const Color.fromARGB(255, 15, 0, 0),
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
      );
  }
  }

// var playlistVideos = await yt.playlists.getVideos(playlist.id);

// Get first 20 playlist videos.
// var somePlaylistVideos = await yt.playlists.getVideos(playlist.id).take(20);

}
