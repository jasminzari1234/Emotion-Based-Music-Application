import 'dart:async';

import 'package:emotify/body.dart';
import 'package:emotify/config.dart';
import 'package:emotify/login.dart';
import 'package:emotify/permission.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Mn.auth = FirebaseAuth.instance;
  Mn.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState(){
 
  super.initState();
   startTimer();
}


 startTimer() {
    Timer(Duration(seconds: 4), () async {
      if (Mn.auth.currentUser != null) {
        Route newRoute = MaterialPageRoute(builder: (_) => MyBody());
        Navigator.pushReplacement(context, newRoute);
      } else {
        /// Not SignedIn
        Route newRoute = MaterialPageRoute(builder: (_) => LoginScreen());
        Navigator.pushReplacement(context, newRoute);
      }
    });
  }



@override
Widget build(BuildContext context){
    return Material(
      child: Container(

                 //decoration: BoxDecoration(
                //    gradient: LinearGradient(
                //      begin: Alignment.topCenter,
                //      end: Alignment.centerLeft,
                //      colors: [
                      //  Color(0xffff7e22),
                      //  Color(0xfffff5fe),
                      //  Color(0xffff9e07),
                //      ])
                //  ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  child: Image.asset('images/logo3.jpg',)),
              ),
              SizedBox(height: 30,),
              Text('Listen Music',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
}
}
