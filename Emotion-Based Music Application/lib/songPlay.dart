import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Songspage extends StatefulWidget {
  String song_name, song_type, song_url, song_interest;

  Songspage(
      {this.song_name,
      this.song_type,
      this.song_url,
      this.song_interest});
  @override
  _SongspageState createState() => _SongspageState();
}

class _SongspageState extends State<Songspage> {
  //MusicPlayer musicPlayer;
   AssetsAudioPlayer assetsAudioPlayer;
  bool isplaying1 = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    //musicPlayer = MusicPlayer();
    assetsAudioPlayer = AssetsAudioPlayer();
  }

  songPlay(String url) async {
    //final assetsAudioPlayer = AssetsAudioPlayer();

    try {
      await assetsAudioPlayer.open(
        Audio.network(url),
      );
      assetsAudioPlayer.play();
      if (isplaying1) {
        // musicPlayer.pause();
        assetsAudioPlayer.pause();
        setState(() {
          isplaying1 = false;
        });
      } else {
        setState(() {
          isplaying1 = true;
        });
      }
    } catch (t) {
      //mp3 unreachable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player App"),
      ),
      body: Center(
        child: Container(
          height: 350,
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
         //color: Colors.greenAccent,
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      widget.song_name,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      widget.song_type,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 50.0,
                    ),
                    IconButton(
                        icon: Icon(isplaying1 ? Icons.pause : Icons.play_arrow),
                        iconSize: 60.0,
                        color: isplaying1 ? Colors.blue : Colors.black,
                        onPressed: () {
                          songPlay(widget.song_url);
                        }),
                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.stop,
                        ),
                        color: isplaying1 ? Colors.black : Colors.blue,
                        iconSize: 60.0,
                        onPressed: () {
                          assetsAudioPlayer.stop();
                          //musicPlayer.stop();
                          setState(() {
                            isplaying1 = false;
                          });
                        }),
                    SizedBox(
                      width: 50.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
