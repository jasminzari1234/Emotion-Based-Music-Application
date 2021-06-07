import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotify/config.dart';
import 'package:emotify/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  
  var authc = FirebaseAuth.instance;

  var fsconnect = FirebaseFirestore.instance;


  
  @override
  Widget build(BuildContext context) {

       user()async{
       authc.signOut().then((_) {
         
                Route newRoute =
                    MaterialPageRoute(builder: (_) => LoginScreen());
                Navigator.pushReplacement(context, newRoute);
              });
  }
       
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.orangeAccent),
            currentAccountPicture: Image.asset('images/profile.jpg'),
            accountName: Text(Mn.sharedPreferences.getString(Mn.userName)),
            accountEmail: Text(Mn.sharedPreferences.getString(Mn.userEmail)),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
                user();
            },
          ),
        ],
      ),
    );


   
  }

  
}
