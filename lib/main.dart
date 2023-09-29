import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ptstube/Playlist.dart';
import 'package:ptstube/audio_player.dart';

import 'nav_bar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Hive.initFlutter('playlists');
  await Hive.initFlutter();
    Hive.registerAdapter<PlaylistLocal>(PlaylistLocalAdapter()); // Register the adapter
  await Hive.openBox<PlaylistLocal>('playlists');
  runApp( NavbarPage());
  // runApp(audplayer());

}

