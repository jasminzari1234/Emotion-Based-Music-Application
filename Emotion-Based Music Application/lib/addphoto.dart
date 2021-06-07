import 'dart:io';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:emotify/config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  bool _isAmplifyConfigured = false;
  String _uploadFileResult = '';
  String _getUrlResult = '';
  File _image;
  PickedFile pickedFile;
  final picker = ImagePicker();
  bool check = false;
  String data1;
  String str = '';
  bool fetch = false;
  // Amplify amplify = new Amplify();

  @override
  void initState() {
    super.initState();
    str = '';
    configureAmplify();
  }

  void configureAmplify() async {
    // First add plugins (Amplify native requirements)
    AmplifyStorageS3 storage = new AmplifyStorageS3();
    AmplifyAuthCognito auth = new AmplifyAuthCognito();

    Amplify.addPlugin(auth);
    Amplify.addPlugin(storage);
    print(Amplify.configure(amplifyconfig));
    if(_isAmplifyConfigured==false){
      await Amplify.configure(amplifyconfig);
    setState(() {
      _isAmplifyConfigured = true;
    });
    }
    // Configure
    


  }

  void _imageClick() async {
    pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        check = true;
      } else {
        print('No image selected.');
      }
    });
  }

  void _upload() async {
    try {
      print('In upload');
      //
      // FilePickerResult result1 = await FilePicker.platform.pickFiles();
      // PlatformFile file = result1.files.first;
      // File local = File(file.path);

      print("local - $_image");
      final key = Mn.sharedPreferences.getString(Mn.userUID);
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'imgName';
      metadata['desc'] = 'selfi photo';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      print("options done");
      showDialog(
          context: context,
          builder: (con) {
            return Center(
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width*0.7,
                color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 30,),
                  Text("Emotion is Detecting...")
                ],
              )
              ));
          });
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: _image, options: options);
      print("-----------file uploaded succesfully------------");
      emotion();
      Navigator.pop(context);
      setState(() {
        _uploadFileResult = result.key;
      });
      print(_uploadFileResult);
    } catch (e) {
      Navigator.pop(context);
      print('UploadFile Err: ' + e.toString());
      _error(e.toString()); //.whenComplete(() => Navigator.pop(context));
      //Navigator.pop(context);
    }
  }
 //    13.232.124.122
 //   /home/ec2-user

// 192.168.43.54
// /cgi-bin/cmd.py
  void emotion() async {
    var url = Uri.http(
      "13.232.124.122",
      "/cgi-bin/cmd.py",{"p":Mn.sharedPreferences.getString(Mn.userUID)}
    );
    print(url);
    var r = await http.get(url);
    print(r.body);

    setState(() {
      str = r.body;
    });
    await Mn.sharedPreferences.setString('emotion',str.toLowerCase());
    print(str);

  _showMyDialog(str);
  }

  Future<void> _showMyDialog(String str) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              str.length>2?
              Text('Your Emotion is Detected\n $str')
              :Text("Face is Not Detected\n Please Try Again")

            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

 Future<void> _error(String str) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please try again....'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.add_a_photo), onPressed: _imageClick),
                  RaisedButton(
                    onPressed: _upload,
                    child: const Text('Get Emotion'),
                  ),
                  //Center(child: CircularProgressIndicator()),
                  Padding(padding: EdgeInsets.all(5.0)),
                ],
              ),
              check ? showImage() : Container(),
              Padding(padding: EdgeInsets.all(5.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget showImage() {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.file(File(pickedFile.path))),
    );
  }
}
