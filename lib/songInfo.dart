import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:spotify_library/editSong.dart';
import 'model/album.dart';
import 'model/song.dart';

class SongInfo extends StatefulWidget {
  final Song selectedSong;
  final Album songAlbum;

  SongInfo({Key? key, required this.selectedSong, required this.songAlbum}) : super(key: key);

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  IconData? _selectedIcon;
  late final _ratingController;
  double _userRating = 3.0;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Song Info"),
          backgroundColor: Colors.green),
      body: SafeArea(
        child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: AlignmentDirectional(-0.9, 0),
            child: Image.network(
              widget.songAlbum.albumCoverImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.9, 0),
            child: Text(
              widget.selectedSong.songTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0),
            child: Text(
              'Released in: ${widget.songAlbum.releaseDate}',
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0),
            child: Text(
              'Album name: ${widget.selectedSong.albumName}',
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0),
            child: Text(
              'Artist name: ${widget.selectedSong.artistName}',
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.9, 0),
            child: Text(
              'Rate the song:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          RatingBarIndicator(
            rating: _userRating,
            itemBuilder: (context, index) => Icon(
              _selectedIcon ?? Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 50.0,
            unratedColor: Colors.amber.withAlpha(50),
            direction: Axis.horizontal,
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter rating',
                labelText: 'Enter rating',
                suffixIcon: MaterialButton(
                  onPressed: () {
                    _userRating =
                        double.parse(_ratingController.text ?? '0.0');
                    setState(() {});
                  },
                  child: Text('Rate'),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0),
            child: TextButton(
                onPressed: () {
                  //redirect back to search
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditSong(songToBeChanged: widget.selectedSong)));
                },
                child: Text("Edit Song Information")
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.8, 0),
            child: TextButton(
                onPressed: () {
                  //redirect back to search
                  Navigator.pop(context);
                },
                child: Text("Search again?")
            ),
          ),
        ],
      ),
        ),
    );
  }
}