import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotify/config.dart';
import 'package:flutter/material.dart';
//import 'package:music_player_app/screens/Songspage.dart';

class SongPlaylist extends StatefulWidget {
  @override
  _SongPlaylistState createState() => _SongPlaylistState();
}

class _SongPlaylistState extends State<SongPlaylist> {
  List<DocumentSnapshot> _list;
  AssetsAudioPlayer assetsAudioPlayer;
  bool isplaying1 = false;
  String songName = "songName";
  Stream<QuerySnapshot<Object>> _stream;
  String songUrl =
      "https://firebasestorage.googleapis.com/v0/b/minor-project-d9ec3.appspot.com/o/mysongs%2FJabKoiBaatRingtone.mp3?alt=media&token=1929537f-46f3-4478-963d-5e7bc6e9bdbd";
  String songType = "type";
  String emotion = Mn.sharedPreferences.getString('emotion');
  //String emotion = 'happy';
  @override
  void initState() {
    super.initState();
    print(emotion);
    initPlatformState();
    setState(() {
      _stream = emotion == "happy\n"
          ? FirebaseFirestore.instance
              .collection('songs')
              .where('type', isEqualTo: 'happy')
              .snapshots()
          : emotion == "sad\n"
              ? FirebaseFirestore.instance
                  .collection('songs')
                  .where('type', isEqualTo: 'sad')
                  .snapshots()
              : emotion == "calm\n"
                  ? FirebaseFirestore.instance
                      .collection('songs')
                      .where('type', isEqualTo: 'calm')
                      .snapshots()
                  : FirebaseFirestore.instance.collection('songs').snapshots();
    });

    // assetsAudioPlayer = AssetsAudioPlayer();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    //musicPlayer = MusicPlayer();
    assetsAudioPlayer = AssetsAudioPlayer();
  }

  songPlay(String url) async {
    //final assetsAudioPlayer = AssetsAudioPlayer();
    print(url);
    try {
      await assetsAudioPlayer.open(
        Audio.network(url),
      );
      assetsAudioPlayer.play();
      if (isplaying1) {
        print("playing....");
        // musicPlayer.pause();
        assetsAudioPlayer.pause();
        setState(() {
          isplaying1 = false;
        });
      } else {
        print("not playing.....");
        setState(() {
          isplaying1 = true;
        });
      }
      print(isplaying1);
    } catch (t) {
      //mp3 unreachable
      print(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _list = snapshot.data.docs;
          int l = 100;
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .7,
                child: ListView.custom(
                    childrenDelegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return buildList(context, _list[index]);
                  },
                  childCount: _list.length,
                )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .086,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration:
                    BoxDecoration(
                      color: Colors.orangeAccent,
                      border: Border.all(color: Colors.orangeAccent)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .07,
                        width: MediaQuery.of(context).size.height * .07,
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'images/music.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height * .03),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songName != null
                                  ? "${songName.substring(0, songName.length - 4)}"
                                  : "",
                              //overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Barlow'),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            Text(
                              songType,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'Barlow'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.03,
                      ),
                      IconButton(
                          icon: Icon(isplaying1
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded),
                          iconSize: MediaQuery.of(context).size.height * 0.07,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            //assetsAudioPlayer.playOrPause();
                            try {
                              // await assetsAudioPlayer.open(
                              //   Audio.network(songUrl),
                              // );
                              assetsAudioPlayer.playOrPause();
                              if (isplaying1) {
                                print("playing....");
                                // musicPlayer.pause();
                                // assetsAudioPlayer.pause();
                                setState(() {
                                  isplaying1 = false;
                                });
                              } else {
                                print("not playing.....");
                                setState(() {
                                  isplaying1 = true;
                                });
                              }
                              print(isplaying1);
                            } catch (t) {
                              //mp3 unreachable
                              print(t);
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildList(BuildContext context, DocumentSnapshot documentSnapshot) {
    int len = documentSnapshot.get("song name").length;
    return InkWell(
      onTap: () async {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Songspage(
        //               song_name: documentSnapshot.data() != null
        //                   ? documentSnapshot.get("song name")
        //                   : "null",
        //               song_type: documentSnapshot.data() != null
        //                   ? documentSnapshot.get("type")
        //                   : "null",
        //               song_url: documentSnapshot.data() != null
        //                   ? documentSnapshot.get("songurl")
        //                   : "null",
        //               song_interest: documentSnapshot.data() != null
        //                   ? documentSnapshot.get("interest")
        //                   : "null",
        //             )));
        //assetsAudioPlayer.play();
        setState(() {
          songName = documentSnapshot.get("song name");
          songUrl = documentSnapshot.get("songurl");
          songType = documentSnapshot.get("type");
          isplaying1 = false;
          len = documentSnapshot.get("song name").length;
          // assetsAudioPlayer.play();
        });
        try {
          await assetsAudioPlayer.open(
            Audio.network(songUrl),
          );
          assetsAudioPlayer.play();
          if (isplaying1) {
            // print("playing....");
            // musicPlayer.pause();
            assetsAudioPlayer.pause();
            setState(() {
              isplaying1 = false;
            });
          } else {
            // print("not playing.....");
            setState(() {
              isplaying1 = true;
            });
          }
          // print(isplaying1);
        } catch (t) {
          //mp3 unreachable
          print(t);
        }
        //assetsAudioPlayer.next();
        print("stop().called");
      },
      child: Container(
        // color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.1,
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.13,
                child: Center(
                  child: Image.asset(
                    'images/music.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "${documentSnapshot.get("song name").substring(0, len - 4)}",
                        softWrap: false,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Container(
                      child: Text(
                        documentSnapshot.get("type"),
                        softWrap: false,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
