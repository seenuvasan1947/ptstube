// import 'package:flutter/material.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class VideoListScreen extends StatelessWidget {
//   final List<Video> videos;

//   const VideoListScreen({
//     Key? key,
//     required this.videos,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Videos'),
//       ),
//       body: ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(videos[index].title),
//             trailing: IconButton(
//               icon: Icon(Icons.play_arrow),
//               onPressed: () {
//                 // Play the video
//                 print(videos[0].title);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }