import 'album.dart';
import 'artist.dart';

class Song {
  final Artist artist;
  final Album album;
  final String songTitle;
  final int averageRating;

  const Song({
    required this.artist,
    required this.album,
    required this.songTitle,
    required this.averageRating,
  });
}