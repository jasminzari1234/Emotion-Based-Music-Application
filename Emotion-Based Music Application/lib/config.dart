

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mn{
static SharedPreferences sharedPreferences ;

   static  String userName = 'name';
   static  String userMobile = 'mobile';
   static  String userAddress = 'address';
   static  String userEmail = 'email';
    static FirebaseAuth auth;
   static String collectionUser = "userdata";
   static  String userUID = 'uid';
}