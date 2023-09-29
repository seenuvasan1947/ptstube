import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'Playlist.dart';
import 'Videolist.dart';

class playlistPage extends StatefulWidget {
  const playlistPage({super.key});

  @override
  State<playlistPage> createState() => _playlistPageState();
}


class _playlistPageState extends State<playlistPage> {
  final List<PlaylistLocal> _playlists = [];

  @override
  void initState() {
    super.initState();
    // Hive.initFlutter('playlists');
    // Hive.registerAdapter(PlaylistLocalAdapter());
    hiveinitilize();

  }

hiveinitilize()

async{
// await Hive.initFlutter();
  // await  Hive.openBox<PlaylistLocal>('playlists');

}

  Future<void> _addPlaylist() async {
  final nameController = TextEditingController();
  final urlController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final playlist = PlaylistLocal(name: nameController.text, url: urlController.text);

              final playlistBox = await Hive.box<PlaylistLocal>('playlists');
              playlistBox.put(playlist.name, playlist);

              setState(() {});

              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Playlist'),
      ),

   body: PlaylistList(),
        floatingActionButton: AddPlaylistDialog(
          onPlaylistAdded: () {
          // This callback will be called when a playlist is added
          setState(() {});
        },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}

class PlaylistList extends StatefulWidget {
  @override
  State<PlaylistList> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  @override
  Widget build(BuildContext context) {
    final playlistsBox = Hive.box<PlaylistLocal>('playlists');

    return ListView.builder(
      itemCount: playlistsBox.length,
      itemBuilder: (context, index) {
        final playlist = playlistsBox.getAt(index) as PlaylistLocal;
        return ListTile(
          title: Text(playlist.name),
          onTap: ()async{

              List<Video> listvid=[];
              // Navigate to a new page to play videos in the playlist
              // print(playlist.name);
              print(playlist.url);

final yt = YoutubeExplode();

    var vidplaylist = await yt.playlists.get(playlist.url);

    var videos=yt.playlists.getVideos(vidplaylist.id);


await for(var video in videos){

listvid.add(video);
}



              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoListScreen(
                    videos: listvid,
                  ),
                ),
              );
          },
          trailing: IconButton(
            icon: Icon(Icons.delete_outlined ),
            onPressed: () async {
await playlistsBox.deleteAt(index).onError((error, stackTrace){
  print(error);
});

setState(() {});

// print(playlistsBox.delete(playlist));

            },
          ),
        );
      },
    );
  }
}





class AddPlaylistDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
   final Function()? onPlaylistAdded; // Callback function

  AddPlaylistDialog({this.onPlaylistAdded});


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(

      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Playlist'),
              content: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: linkController,
                    decoration: InputDecoration(labelText: 'Link'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final name = nameController.text;
                    final link = linkController.text;
                    final playlist = PlaylistLocal(name: name,url: link);
                    final playlistsBox = Hive.box<PlaylistLocal>('playlists');
                    playlistsBox.add(playlist);
                     if (onPlaylistAdded != null) {
                      onPlaylistAdded!();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}