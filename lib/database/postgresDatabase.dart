import 'package:postgres/postgres.dart';
import 'package:spotify_library/model/album.dart';
import 'package:spotify_library/model/artist.dart';
import 'package:spotify_library/model/song.dart';

class PostgresDatabase {

  PostgreSQLConnection? connection;

  PostgresDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
      'spotify-flutter-db-instance.ccfp66mpr4kg.us-west-2.rds.amazonaws.com',
      5432,
      'initial_db',
      username: 'postgres',
      password: 'o!tCl9D74ozR',
      timeoutInSeconds: 60,
      queryTimeoutInSeconds: 60,
      timeZone: 'UTC',
      useSSL: false,
      isUnixSocket: false,
    )
        : connection);
  }

  //Get all artists with a given artistName
  Future<List<Artist>> searchArtists(String artistName) async {
    List<Artist> artists = [];
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> artistResults = await newConnection.mappedResultsQuery(
          "select * from artist where artist_name = @artistName",
          substitutionValues: {'artistName': artistName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        //map results
        for (final row in artistResults) {
          String name = row["artist"]!["artist_name"];
          String profilePicture = row["artist"]!["profile_picture"];
          Artist newArtist = Artist(name: name, profilePicture: profilePicture);
          artists.add(newArtist);
        }
      });
    }
    catch (exc){
      print(exc.toString());
    }
  return artists;
}

//Get all albums with a given albumName
  Future<List<Album>> searchAlbums(String albumName) async {
    List<Album> albums = [];
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> albumResults = await newConnection.mappedResultsQuery(
          "select * from album where album_name = @albumName",
          substitutionValues: {'albumName': albumName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        //map results
        for (final row in albumResults) {
          String albumName= row["album"]!["album_name"];
          String coverPicture = row["album"]!["album_cover"];
          String releaseDate = row["album"]!["release_date"];
          String artistName = row["album"]!["a_artist_name"];
          Album newAlbum = Album(albumCoverImage: coverPicture, albumName: albumName,
              releaseDate: releaseDate, artistName: artistName);
          albums.add(newAlbum);
        }
      });
    }
    catch (exc){
      print(exc.toString());
    }
    return albums;
  }

  //Get all songs with a given songName
  Future<List<Song>> searchSongs(String songName) async {
    List<Song> songs = [];
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> albumResults = await newConnection.mappedResultsQuery(
          "select * from song where song_title = @songName",
          substitutionValues: {'songName': songName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        //map results
        for (final row in albumResults) {
          String songTitle = row["song"]!["song_title"];
          String albumName = row["song"]!["s_album_name"];
          int averageRating = row["song"]!["average_rating"];
          String artistName = row["song"]!["s_artist_name"];
          Song newSong = Song(artistName: artistName, albumName: albumName,
              songTitle: songTitle, averageRating: averageRating);
          songs.add(newSong);
        }
      });
    }
    catch (exc){
      print(exc.toString());
    }
    return songs;
  }

  //Check if valid user
  Future<bool> checkValidUser(String username, String password) async {
    bool validUser = false;
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<List<dynamic>> userResults = await newConnection.query(
          "select u_password from users where username = @username",
          substitutionValues: {'username': username, 'password': password},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        for (final row in userResults) {
          String result = row[0];
          if(result == password) {
            validUser = true;
          }
        }
      });
    }
    catch (exc){
      print(exc.toString());
    }
    return validUser;
  }
}