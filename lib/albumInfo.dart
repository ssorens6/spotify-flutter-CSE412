import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/album.dart';
import 'model/song.dart';

class AlbumInfo extends StatefulWidget {
  final Album selectedAlbum;
  final List<Song> albumSongs;
  AlbumInfo({Key? key, required this.selectedAlbum, required this.albumSongs}) : super(key: key);

  @override
  State<AlbumInfo> createState() => _AlbumInfoState();
}

class _AlbumInfoState extends State<AlbumInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Album Info"),
        backgroundColor: Colors.green),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.9, 0),
                child: Image.network(
                  widget.selectedAlbum.albumCoverImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.9, 0),
                child: Text(
                  '${widget.selectedAlbum.albumName} songs:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.9, 0),
                child: Text(
                  'Released ${widget.selectedAlbum.releaseDate} by ${widget.selectedAlbum.artistName}',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ListView.builder(
                    itemCount: widget.albumSongs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(widget.albumSongs[index].songTitle));
                    }),
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
      ),
    );
  }
}