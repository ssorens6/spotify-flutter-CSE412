import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/album.dart';
import 'model/artist.dart';

class ArtistInfo extends StatefulWidget {
  final Artist selectedArtist;
  final List<Album> artistAlbums;
  ArtistInfo({Key? key, required this.selectedArtist, required this.artistAlbums}) : super(key: key);

  @override
  State<ArtistInfo> createState() => _ArtistInfoState();
}

class _ArtistInfoState extends State<ArtistInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Artist Info"),
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
                  widget.selectedArtist.profilePicture,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.95, 0),
                child: Text(
                  '${widget.selectedArtist.name} Album\'s',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ListView.builder(
                    itemCount: widget.artistAlbums.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network(
                          widget.artistAlbums[index].albumCoverImage,
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                          title: Text(widget.artistAlbums[index].albumName));
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