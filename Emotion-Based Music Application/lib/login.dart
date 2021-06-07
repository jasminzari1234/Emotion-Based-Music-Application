

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotify/body.dart';
import 'package:emotify/config.dart';
import 'package:emotify/customTextField.dart';
import 'package:emotify/errorDialog.dart';
import 'package:emotify/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


class _LoginScreenState extends State<LoginScreen> {

  var authc = FirebaseAuth.instance;

  var fsconnect = FirebaseFirestore.instance;


    @override
  void initState() {
    super.initState();
      setemotion();
       
  }

  setemotion()async{
   await Mn.sharedPreferences.setString('emotion', '');
  }
  

@override
Widget build(BuildContext context){
     return Scaffold(

       body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle.light,
         child: GestureDetector(
           child: Stack(
             children: <Widget>[
               Container(
                 height: double.infinity,
                 width : double.infinity,
                 color: Colors.orangeAccent.shade200,
                //  decoration: BoxDecoration(
                //    gradient: LinearGradient(
                //      begin: Alignment.topRight,
                //      end: Alignment.centerLeft,
                //      colors: [
                //        Color(0xffff7e22),
                //        Color(0xfffff5fe),
                //        Color(0xffff8e07),
                //      ])
                //  ),
              child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 120
                ),
                   child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text(
                       'Sign In',
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 40,
                         fontWeight: FontWeight.bold
                       ),
                     ),
                     SizedBox(height: 50,),
                
                   CustomTextField(
                    data: Icons.person_outline,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                   ),
                   SizedBox(height: 10,),
                   CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                     
                   SizedBox(height: 10,),
                  
                   Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: RaisedButton(
                             onPressed: () {
                               _emailController.text.isNotEmpty &&
                               _passwordController.text.isNotEmpty
                               ? _login()
                               : showDialog(
                                 context: context,
                                 builder: (con) {
                                 return ErrorAlertDialog(
                                    message: 'Please fill the desired fields',
                                 );
                               });
                             },
                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                   color: Colors.orangeAccent.shade700,
                   child: Text(
                      'Login',
                   style: TextStyle(
                   color: Colors.black,
                   fontSize: 18,
                   fontWeight: FontWeight.bold
                   ),
                   ),
                   ),
                  ),

                      SizedBox(height: 10,),
                     _signup(),
                      SizedBox(height: 5,),
                      Divider(height: 30,thickness: 3.0,color: Colors.black,),
                      _admin()
                   ],
                 ),
             ),
               )  
             ],
             )
         ),
       )
     );
}

_signup(){
    return Container(
       padding: EdgeInsets.symmetric(vertical: 10),
       width: double.infinity,
       child: FlatButton(
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RegScreen()));
            },
            child: Text(
               'Don\'t have an Account?Sign Up',

               style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),),
           );
}

_admin(){
   return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        child: FlatButton(
              onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminLogin()));
              },
              child: Text(
                  'admin login',
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 18,
                     fontWeight: FontWeight.bold
                    ),
              ),),
        );
}

showMyDialog(String message) {
    showDialog(
        context: context,
        builder: (con) {
          return ErrorAlertDialog(
            message: message,
          );
        });
  }
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Invalid Password Or username'),
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

  void _login() async {
    try {
     var userNew = await authc.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
     );
     print(userNew);
     var em = userNew.user.email;
     var uid = userNew.user.uid;
     showDialog(
        context: context,
        builder: (con) {
        return Center(child: CircularProgressIndicator());
        });
     if (userNew != null) {
      readDataToDataBase(em,uid).then((s) {   
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyBody()));
      });
     }
    } catch (e) {
        _showMyDialog().then((value) {
                  _emailController.clear();
        _passwordController.clear();
        });
      print('password or username is incorrect');
    }

  }


  // ignore: deprecated_member_use
  Future readDataToDataBase(em,uid) async {
    try {
       DocumentSnapshot snapshot = await fsconnect
        .collection('userdata')
        .doc(uid)
        .get();
    print('collection');
    await Mn.sharedPreferences.setString(Mn.userUID, snapshot.get('uid'));
    await Mn.sharedPreferences.setString(Mn.userEmail,snapshot.get('email'));
    await Mn.sharedPreferences.setString(Mn.userName, snapshot.get('name'));
    await Mn.sharedPreferences.setString(Mn.userMobile, snapshot.get('mobile'));
    
    print(Mn.sharedPreferences.getString(Mn.userUID));
    print(Mn.sharedPreferences.getString(Mn.userEmail));
    print(Mn.sharedPreferences.getString(Mn.userName));
    } catch (e) {
      showMyDialog(e.toString());
      print("error found");
    }
  }
}
