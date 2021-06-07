import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSongs extends StatefulWidget {
  @override
  _AddSongsState createState() => _AddSongsState();
}

class _AddSongsState extends State<AddSongs> {
  PlatformFile file;
  var authc = FirebaseAuth.instance;
  var fsconnect = FirebaseFirestore.instance;
  String songName;
  String songUrl;
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();

  void onTabBar(String sn) {
    setState(() {
      songName = sn;
    });
  }

  void onTabUrl(String su) {
    setState(() {
      songUrl = su;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        songButton(),
        // RaisedButton(
        //   onPressed: () => print("Select song clicked....."),
        //   child: Text("Select Song"),
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: _typeController,
            decoration: InputDecoration(
              hintText: "Enter song type",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: TextField(
            controller: _interestController,
            decoration: InputDecoration(
              hintText: "Enter song Interest",
            ),
          ),
        ),
        RaisedButton(
          onPressed: () => uploadButton(),
          child: Text("Upload"),
        ),
      ],
    ));
  }

  songButton() {
    return RaisedButton(
      color: Colors.greenAccent,
      child: Text("add song"),
      onPressed: () async {
        FilePickerResult result = await FilePicker.platform.pickFiles();

        FirebaseStorage storage = FirebaseStorage.instance;
        if (result != null) {
          file = result.files.first;

          songName = file.name.toString();
          Reference ref = storage.ref().child("mysongs").child("$songName");
          UploadTask uploadTask = ref.putFile(File(file.path));

          await uploadTask.whenComplete(() {
            ref.getDownloadURL().then((value) => {
                  songUrl = value,
                  onTabUrl(songUrl),
                  print("songurl " + songUrl)
                });
          }).catchError((onError) {
            print(onError);
          });

          onTabBar(songName);
          print(songUrl);
          print(file.name);
          print(file.size);
          print(file.extension);
        } else {
          // User canceled the picker
        }
      },
    );
  }

  uploadButton() async {
    fsconnect.collection('songs').add({
      'song name': songName,
      'type': _typeController.text,
      'interest': _interestController.text,
      'songurl': songUrl
    }).then((value) {
      //Fluttertoast.showToast(msg: 'item uploaded successfully');
      _typeController.clear();
      _interestController.clear();
      setState(() {});
    });
  }
}
