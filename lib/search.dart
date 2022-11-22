import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

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
                //Todo: display search results
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
