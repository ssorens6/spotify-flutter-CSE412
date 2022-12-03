import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:spotify_library/database/postgresDatabase.dart';

import 'model/album.dart';
import 'model/artist.dart';
import 'model/song.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int tag = 1;
  List<String> options = [
    'Song', 'Album', 'Artist',
  ];
  final searchTextController = TextEditingController();
  String searchText = "";

  late List<Song> foundSongs;
  late List<Artist> foundArtists;
  late List<Album> foundAlbums;

  @override
  void initState() {
    // initializing states
    foundSongs = [];
    foundArtists = [];
    foundAlbums = [];

    super.initState();
  }
  void _setText() {
    setState(() {
      searchText = searchTextController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: <Widget>[
          Text(
            'Search',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
            ),
            controller: searchTextController,
          ),
      ChipsChoice<int>.single(
        value: tag,
        onChanged: (val) => setState(() => tag = val),
        choiceItems: C2Choice.listFrom<int, String>(
          source: options,
          value: (i, v) => i,
          label: (i, v) => v,
        ),
      ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                _setText();
                switch(tag) {
                  // song tag is selected in search
                  case 0: {
                    //get songs from postgres
                    PostgresDatabase().searchSongs(searchText).then((fetchedSongs) =>
                    {
                      foundSongs.clear(),
                      fetchedSongs.forEach((song) =>
                      {
                        print(song),
                        setState(() {
                          foundSongs.add(song);
                        })
                      })
                    });
                  }
                  break;
                  //album tag is selected in search
                  case 1: {
                    //get albums from postgres
                    PostgresDatabase().searchAlbums(searchText).then((fetchedAlbums) =>
                    {
                      foundAlbums.clear(),
                      fetchedAlbums.forEach((album) =>
                      {
                        print(album),
                        setState(() {
                          foundAlbums.add(album);
                        })
                      })
                    });
                  }
                  break;
                  //artist tag is selected in search
                  case 2: {
                    //get artists from postgres
                    PostgresDatabase().searchArtists(searchText).then((fetchedArtists) =>
                    {
                      foundArtists.clear(),
                      fetchedArtists.forEach((artist) =>
                      {
                        print(artist),
                        setState(() {
                          foundArtists.add(artist);
                        })
                      })
                    });
                  }
                  break;
                }
              },
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          Container(
            height: 300,
            width: 300,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: _buildListItems(),
            ),
          )
          ],
        ),
    );
  }
  List<Widget> _buildListItems() {
    switch(tag) {
      case 0: {
        // song
        if(foundSongs.isEmpty) {
          return [
            Text('No results found'),
          ];
        }
        else {
          List<Widget> songWidgetTiles = [];
          foundSongs.forEach((element)=>{
            songWidgetTiles.add(TextButton(
                onPressed: () {
                  //Todo: redirect to album site
                },
                child: Text(element.songTitle)
            )),
          });
          return songWidgetTiles;
        }
      }
      break;

      case 1: {
        //album
        if(foundAlbums.isEmpty) {
          return [
            Text('No results found'),
          ];
        }
        else {
          List<Widget> albumWidgetTiles = [];
          foundAlbums.forEach((element)=>{
            albumWidgetTiles.add(TextButton(
                onPressed: () {
                  //Todo: redirect to album site
                },
                child: Text(element.albumName)
            )),
          });
          return albumWidgetTiles;
        }
      }
      break;
      case 2: {
        //artists
        if(foundArtists.isEmpty) {
          return [
            Text('No results found'),
          ];
        }
        else {
          List<Widget> artistWidgetTiles = [];
          foundArtists.forEach((element)=>{
            artistWidgetTiles.add(TextButton(
                onPressed: () {
                  //Todo: redirect to artist site
            },
                child: Text(element.name)
            )),
          });
          return artistWidgetTiles;
        }
      }
      break;
      default: {
        return [
          Text('No results found'),
        ];
      }
      break;

    }

  }
}
