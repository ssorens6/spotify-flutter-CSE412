import 'album.dart';
import 'artist.dart';

class Song {
  final String artistName;
  final String albumName;
  final String songTitle;
  final int averageRating;

  const Song({
    required this.artistName,
    required this.albumName,
    required this.songTitle,
    required this.averageRating,
  });
}