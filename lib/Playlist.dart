import 'package:hive/hive.dart';

part 'Playlist.g.dart';

@HiveType(typeId: 0)
class PlaylistLocal {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String url;

  PlaylistLocal({required this.name, required this.url});
}