import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_library/database/postgresDatabase.dart';

import 'model/song.dart';

class EditSong extends StatefulWidget {
  final Song songToBeChanged;
  const EditSong({Key? key, required this.songToBeChanged}) : super(key: key);
  @override
  State<EditSong> createState() => _EditSongState();
}

class _EditSongState extends State<EditSong> {
  TextEditingController songNewNameController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    songNewNameController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Edit Song"),
          backgroundColor: Colors.green),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text(
                    'Editing Song: ${widget.songToBeChanged.songTitle}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text(
                    'Enter Song\'s New Title:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                TextFormField(
                  controller: songNewNameController,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'put your song new name here',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.85, 0),
                  child: TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {
                        PostgresDatabase().editSong(widget.songToBeChanged.songTitle, songNewNameController.text, widget.songToBeChanged.artistName, widget.songToBeChanged.albumName, widget.songToBeChanged.averageRating.toString());
                        Navigator.pop(context);
                      },
                      child: Text('Save Song Information')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}