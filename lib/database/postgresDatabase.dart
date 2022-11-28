import 'package:postgres/postgres.dart';

class PostgresDatabase {
  //Todo: complete file to create correct tables see (https://github.com/beautybird/Flutter-with-Postgresql-using-Models-class/blob/master/lib/database/app_database.dart)

  PostgreSQLConnection? connection;

  PostgresDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
      'spotify-flutter-db-instance.ccfp66mpr4kg.us-west-2.rds.amazonaws.com',
      5432,
      'initial_db',
      username: 'postgres',
      password: '',
      timeoutInSeconds: 60,
      queryTimeoutInSeconds: 60,
      timeZone: 'UTC',
      useSSL: false,
      isUnixSocket: false,
    )
        : connection);
  }

  //Method for testing if database works
  String newDataFuture = '';

  Future<String> getData(String songName) async {
    try {
      await connection!.open();
    }
    catch (exc) {
      newDataFuture = 'error';
    }
    return newDataFuture;
  }
}