import 'package:emotify/addphoto.dart';
import 'package:emotify/addsongs.dart';
import 'package:emotify/drawer.dart';
import 'package:emotify/songPlaylist.dart';
import 'package:flutter/material.dart';


class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  Color col;
  int _currentIndex = 0;
  final List<Widget> _children= [
     Photo(),
     SongPlaylist(),
     AddSongs(),
  ];

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

void onTabBar(int index){
           setState(() {
                 col = Colors.orangeAccent;
                  _currentIndex = index;
            });
}
  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: new Scaffold(
            backgroundColor: Colors.orangeAccent.shade100,
      appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text("Emotify",style: TextStyle(color: Colors.black),),
      ),
      drawer: MyDrawer(),
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
       showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
           onTap: onTabBar,
           currentIndex: _currentIndex,
          items:[
            BottomNavigationBarItem(
              
              icon:Icon(Icons.camera,color: col ,),
              title: Text('camera',style: TextStyle(color:  Colors.white)),
            
            ),          
            BottomNavigationBarItem(
              icon:Icon(Icons.library_music,color: col ,),
              title: Text('songs',style: TextStyle(color:  Colors.white),),
           
            ),

             BottomNavigationBarItem(
              icon:Icon(Icons.add,color: col ,),
              title: Text('add Song',style: TextStyle(color:  Colors.white)),
              
            ),
          ],
          ),
    ),
        );
  }
}
