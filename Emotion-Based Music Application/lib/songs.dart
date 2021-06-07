import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double screenHeight = 0;
  double screenWidth = 0;
  final Color mainColor = Color(0xff181c27);
  final Color inactiveColor = Color(0xff5d6169);

  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    assetsAudioPlayer.open(
                  Audio.network("http://www.mysite.com/myMp3file.mp3"),
                );
    //audioPlayer.open(Playlist(), autoStart: false, loopMode: LoopMode.playlist);
  }

  final assetsAudioPlayer = AssetsAudioPlayer();

  void playSong() async {
    try {
      // await assetsAudioPlayer.open(
      //   Audio.network(url),
      // );
      setState(() {
        assetsAudioPlayer.playOrPause();
      });
    } catch (t) {
      print("error " + t.toString());
    }
  }

  Widget playButton() {
    return Container(
      width: screenWidth * 0.25,
      child: TextButton(
          onPressed: () => audioPlayer.playlistPlayAtIndex(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                color: mainColor,
              ),
              SizedBox(width: 5),
              Text(
                'Play',
                style: TextStyle(color: mainColor),
              ),
            ],
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )))),
    );
  }

  Widget playlist(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      height: screenHeight * 0.35,
      alignment: Alignment.bottomLeft,
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('songs').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return playlistItem(snapshot, index, context);
                      },
                    );
            }),
      ),
      // child: ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: audioList.length,
      //     itemBuilder: (context, index) {
      //       return playlistItem(index);
      //     }),
    );
  }

  Widget playlistItem(AsyncSnapshot<QuerySnapshot<Object>> snapshot, int index,
      BuildContext context) {
    return InkWell(
      onTap: () => audioPlayer.playlistPlayAtIndex(index),
      splashColor: Colors.transparent,
      highlightColor: mainColor,
      child: Container(
        height: screenHeight * 0.07,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data.docs[index].get("song name"),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow'),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      snapshot.data.docs[index].get("type"),
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff5d6169),
                          fontFamily: 'Barlow'),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.menu_rounded,
                color: inactiveColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomPlayContainer(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.08,
              width: screenHeight * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                // child: Image.asset(
                //   realtimePlayingInfos.current.audio.audio.metas.image.path,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "song name",
                    style: TextStyle(
                        fontSize: 15,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow'),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    "type",
                    style: TextStyle(
                        fontSize: 13, color: mainColor, fontFamily: 'Barlow'),
                  )
                ],
              ),
            ),
            Icon(
              Icons.favorite_outline_rounded,
              color: mainColor,
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            IconButton(
                icon: Icon(realtimePlayingInfos.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded),
                iconSize: screenHeight * 0.07,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: mainColor,
                onPressed: () => audioPlayer.playOrPause())
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        //backgroundColor: mainColor,
        body: Container(
      //color: Colors.amber,
      height: screenHeight * 0.35,
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                // assetsAudioPlayer.open(
                //   Audio.network("http://www.mysite.com/myMp3file.mp3"),
                // );
                // assetsAudioPlayer.playOrPause();
                playSong();
              })
        ],
      ),

      // child: StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance.collection('songs').snapshots(),
      //     builder: (context, snapshot) {
      //       return !snapshot.hasData
      //           ? Center(child: CircularProgressIndicator())
      //           : ListView.builder(
      //               itemCount: snapshot.data!.docs.length,
      //               itemBuilder: (context, index) {
      //                 return InkWell(
      //                   onTap: () => playSong(
      //                       snapshot.data!.docs[index].get("song name")),
      //                   //splashColor: Colors.transparent,
      //                   //highlightColor: mainColor,
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                         color: Colors.amber,
      //                         height: screenHeight * 0.1,
      //                         child: Padding(
      //                           padding:
      //                               const EdgeInsets.only(left: 20, right: 20),
      //                           child: Container(
      //                             // color: Color.accents,
      //                             child: Row(
      //                               children: [
      //                                 SizedBox(width: screenWidth * 0.04),
      //                                 Expanded(
      //                                   child: Column(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.center,
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text(
      //                                         snapshot.data!.docs[index]
      //                                             .get("song name"),
      //                                         style: TextStyle(
      //                                             fontSize: 15,
      //                                             color: Colors.black,
      //                                             fontWeight: FontWeight.bold,
      //                                             fontFamily: 'Barlow'),
      //                                       ),
      //                                       SizedBox(
      //                                           height: screenHeight * 0.005),
      //                                       Text(
      //                                         snapshot.data!.docs[index]
      //                                             .get("type"),
      //                                         style: TextStyle(
      //                                             fontSize: 13,
      //                                             color: Color(0xff5d6169),
      //                                             fontFamily: 'Barlow'),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 Icon(
      //                                   Icons.play_arrow,
      //                                   color: inactiveColor,
      //                                 )
      //                               ],
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       )
      //                     ],
      //                   ),
      //                 );
      //               },
      //             );
      //     }),
    ));
  }
}
