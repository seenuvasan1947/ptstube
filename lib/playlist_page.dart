import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'Playlist.dart';
import 'Videolist.dart';
import 'modules.dart';

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

  hiveinitilize() async {
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
          title: const Text('Add Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final playlist = PlaylistLocal(
                    name: nameController.text, url: urlController.text);

                final playlistBox = await Hive.box<PlaylistLocal>('playlists');
                playlistBox.put(playlist.name, playlist);

                setState(() {});

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
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
        title: const Text('YouTube Playlist'),
      ),
      body: PlaylistList(),
      floatingActionButton: AddPlaylistDialog(
        onPlaylistAdded: () {
          // This callback will be called when a playlist is added
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class PlaylistList extends StatefulWidget {
  @override
  State<PlaylistList> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  ScrollController _scrollController = ScrollController();

  Future<int> getvidcount(String play_list_url) async {
    List<Video> listvid = [];
    // Navigate to a new page to play videos in the playlist
    // print(playlist.name);
    // print(playlist.url);

    final yt = YoutubeExplode();

    var vidplaylist = await yt.playlists.get(play_list_url);

    var videos = yt.playlists.getVideos(vidplaylist.id);

    // await for (var video in videos) {
    //   listvid.add(video);
    // }

    return videos.length;
  }

  @override
  Widget build(BuildContext context) {
    final playlistsBox = Hive.box<PlaylistLocal>('playlists');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).height*0.1,),
          SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.91,
              height: MediaQuery.sizeOf(context).height * 0.87,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: playlistsBox.length,
                itemBuilder: (context, index) {
                  final playlist = playlistsBox.getAt(index) as PlaylistLocal;
                  return Card(
                    color: Colors.deepPurple[200],
                    child: InkWell(
                      onTap: () async {
                        List<Video> listvid = [];
                        // Navigate to a new page to play videos in the playlist
                        // print(playlist.name);
                        print(playlist.url);

                        final yt = YoutubeExplode();

                        var vidplaylist = await yt.playlists.get(playlist.url);

                        var videos = yt.playlists.getVideos(vidplaylist.id);

                        await for (var video in videos) {
                          listvid.add(video);
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoListScreen(
                              videos: listvid,
                              playlistname:playlist.name
                            ),
                          ),
                        );
                      },
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(50.0),
                          bottom: Radius.circular(50.0)),
                      splashColor: Colors.pink,
                      child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //     Text(playlist.name,
                          //         style: const TextStyle(fontSize: 16.0)),

                          //     SizedBox(width: MediaQuery.sizeOf(context).width*0.15,),
                                  
                              
                          //   ],
                          // ),
                           SingleChildScrollView(
                                   scrollDirection: Axis.horizontal,
                                child: Text(playlist.name,
                                    style: const TextStyle(fontSize: 16.0)),
                              ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FutureBuilder<int>(
                              future: getvidcount(playlist.url),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                      ""); // Display a loading indicator
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else
                                  return Text(
                                    'length:${snapshot.data}',
                                    style: const TextStyle(fontSize: 16.0),
                                  );
                              },
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Audio',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  playlistviddownload(playlist.url,PlaylistContentType.audio,'mp3','Music');
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Video',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                   playlistviddownload(playlist.url,PlaylistContentType.video,'mp4','Movies');
                                },
                              ),
                                SizedBox(width: MediaQuery.sizeOf(context).width*0.08,),
                              IconButton(
                                icon: const Icon(Icons.delete_outlined),
                                onPressed: () async {
                                  await playlistsBox
                                      .deleteAt(index)
                                      .onError((error, stackTrace) {
                                    print(error);
                                  });

                                  setState(() {});

                                  // print(playlistsBox.delete(playlist));
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
          ),
        ],
      ),
    );
  }
}

/* ListTile(
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
                ); */

class AddPlaylistDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final Function()? onPlaylistAdded; // Callback function

  AddPlaylistDialog({this.onPlaylistAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      autofocus: true,
      backgroundColor: Colors.deepPurpleAccent,
      // elevation: 90.0,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Playlist'),
              content: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: 'Link'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final name = nameController.text;
                    final link = linkController.text;
                    final playlist = PlaylistLocal(name: name, url: link);
                    final playlistsBox = Hive.box<PlaylistLocal>('playlists');
                    playlistsBox.add(playlist);
                    if (onPlaylistAdded != null) {
                      onPlaylistAdded!();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
