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

  //Get all albums with a given a_artist_name
  Future<List<Album>> searchAlbumsByArtist(String artistSearchName) async {
    List<Album> albums = [];
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> albumResults = await newConnection.mappedResultsQuery(
          "select * from album where a_artist_name = @artistSearchName",
          substitutionValues: {'artistSearchName': artistSearchName},
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

  Future<List<Song>> searchSongsbyAlbum(String albumSearchName) async {
    List<Song> songs = [];
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> albumResults = await newConnection.mappedResultsQuery(
          "select * from song where s_album_name = @albumSearchName",
          substitutionValues: {'albumSearchName': albumSearchName},
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

//adds a song to database
  PostgreSQLResult? newSongResult, newAlbumResult, newArtistResult;
  PostgreSQLResult? songExists, artistExists, albumExists;
  Future<String> addSong(String songTitle, String artistName, String albumName, String albumCover, String profilePic, String releaseDate) async {
    String newSongFuture = '';
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        songExists = await newConnection.query(
          "select * from song where song_title = @songTitle",
          substitutionValues: {'songTitle': songTitle},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        albumExists = await newConnection.query(
          "select * from album where album_name = @albumName",
          substitutionValues: {'albumName': albumName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        artistExists = await newConnection.query(
          "select * from artist where artist_name = @artistName",
          substitutionValues: {'artistName': artistName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (songExists!.affectedRowCount > 0) {
          newSongFuture = 'alr';
        } else {
          if (albumExists!.affectedRowCount > 0) {
            //album exists, do nothing
          } else {
            if (artistExists!.affectedRowCount > 0) {
              //artist exists, do nothing
            } else {
              newArtistResult = await newConnection.query(
                'insert into artist(artist_name, profile_picture) '
                    'values (@artistName, @profilePic)',
                substitutionValues: {
                  'artistName': artistName,
                  'profilePic': profilePic,
                },
                allowReuse: true,
                timeoutInSeconds: 30,
              );
            }
            newAlbumResult = await newConnection.query(
              'insert into album(a_artist_name, album_cover, album_name, release_date) '
                  'values (@artistName, @albumCover, @albumName, @releaseDate)',
              substitutionValues: {
                'artistName': artistName,
                'albumCover': albumCover,
                'albumName': albumName,
                'releaseDate': releaseDate
              },
              allowReuse: true,
              timeoutInSeconds: 30,
            );
          }
          newSongResult = await newConnection.query(
            'insert into song(s_artist_name, s_album_name, song_title, average_rating) '
                'values (@artistName, @albumName, @songName, @rating)',
            substitutionValues: {
              'artistName': artistName,
              'albumName': albumName,
              'songName': songTitle,
              'rating': 0
            },
            allowReuse: true,
            timeoutInSeconds: 30,
          );
          newSongFuture = (newSongResult!.affectedRowCount > 0 ? 'reg' : 'nop');
        }
      });
    }
    catch (exc){
      newSongFuture = 'exc';
      exc.toString();
    }
    return newSongFuture;
  }

//edits a song in database
  PostgreSQLResult? addSongResult, deleteSongResult, deleteLibResult;
  Future<String> editSong(String oldSongTitle, String newSongTitle, String artistName, String albumName, String average_rating) async {
    String newSongFuture = '';
    try {
      await connection!.open();
      await connection!.transaction((newConnection) async {
        deleteLibResult = await newConnection.query(
          'delete from lib where l_song_title=@oldSongTitle',
          substitutionValues: {
            'oldSongTitle': oldSongTitle
          },
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        deleteSongResult = await newConnection.query(
          'delete from song where song_title=@oldSongTitle',
          substitutionValues: {
            'oldSongTitle': oldSongTitle
          },
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        addSongResult = await newConnection.query(
          'insert into song(s_artist_name, s_album_name, song_title, average_rating) '
              'values (@artistName, @albumName, @newSongTitle, @rating)',
          substitutionValues: {
            'artistName': artistName,
            'albumName': albumName,
            'newSongTitle': newSongTitle,
            'rating': 3
          },
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        newSongFuture = (addSongResult!.affectedRowCount > 0 ? 'upd' : 'nop');
      });
    } catch (exc) {
      newSongFuture = 'exc';
      print(exc.toString());
    }
    return newSongFuture;
  }


}