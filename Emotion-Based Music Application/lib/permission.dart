import 'package:emotify/addphoto.dart';
import 'package:emotify/songPlaylist.dart';
import 'package:flutter/material.dart';

class Permission extends StatefulWidget {
  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {

    @override
  void initState() {
    super.initState();
    showMyDialog();
  }

  Future<void> showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do You Want to Detect Emotion'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SongPlaylist()));
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Photo()));
            },
          ),          
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Emotify"),
      ),
      body: Container()
    );
  }
}

