import 'package:postgres/postgres.dart';
import 'package:spotify_library/model/artist.dart';

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
    print("connection complete");
  }

  //Get all artists with a given artistName
  Future<List<Artist>> searchArtists(String artistName) async {
    print("Gettting search results");
    List<Artist> artists = [];
    try {
      await connection!.open();
      print("connection open");
      await connection!.transaction((newConnection) async {
        List<Map<String, Map<String, dynamic>>> artistResults = await newConnection.mappedResultsQuery(
          'select * from artist where artist_name like %@artistName%',
          substitutionValues: {'artistName': artistName},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        //map results
        for (final row in artistResults) {
          String name = row["artist_name"].toString();
          print(name);
          String profilePicture = row["profile_picture"].toString();
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
}