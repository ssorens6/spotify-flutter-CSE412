import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:spotify_library/database/postgresDatabase.dart';

import 'model/artist.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int tag = 1;
  List<String> options = [
    'Song', 'Album', 'Artist',
  ];

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
                //Todo: display search results\
                print("MAde it here");
                print(tag);
                switch(tag) {
                  // song tag is selected in search
                  case 0: {

                  }
                  break;
                  //album tag is selected in search
                  case 1: {

                  }
                  break;
                  //artist tag is selected in search
                  case 2: {
                    //get artists from postgres
                    PostgresDatabase().searchArtists("BTS").then((fetchedArtists) =>
                        fetchedArtists.forEach((artist) =>
                            print(artist)
                        )
                    );
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
          ],
        ),
    );
  }
}
