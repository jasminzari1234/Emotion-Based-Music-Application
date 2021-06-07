import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotify/body.dart';
import 'package:emotify/config.dart';
import 'package:emotify/customTextField.dart';
import 'package:emotify/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegScreen extends StatefulWidget {
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  var authc = FirebaseAuth.instance;
  var fsconnect = FirebaseFirestore.instance;
  String email;
  String name;
  String mobile;
  String password;
  String address;
 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

    @override
  void initState() {
    super.initState();
      setemotion();
       
  }

  setemotion()async{
   await Mn.sharedPreferences.setString('emotion', '');
  }


Widget build(BuildContext context){
     return Scaffold(
       body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle.light,
         child: GestureDetector(
           child: Stack(
             children: <Widget>[
               Container(
                color: Colors.orangeAccent.shade200,
                 height: double.infinity,
                 width : double.infinity,
                //  decoration: _decoration(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 80
                   ),
                  child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text(
                            'Register',
                             style: TextStyle(
                             color: Colors.black,
                             fontSize: 40,
                             fontWeight: FontWeight.bold
                         ),),
                 SizedBox(height: 30,),
                  CustomTextField(
                    data: Icons.person_outline,
                    controller: _nameController,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  SizedBox(height: 10,),
                  CustomTextField(
                    data: Icons.email,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  SizedBox(height: 10,),
                  CustomTextField(
                    data: Icons.phone,
                    controller: _mobileController,
                    hintText: 'Mobile',
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
                  CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordConfirmController,
                    hintText: 'Confirm passsword',
                    isObsecure: true,
                  ),
                  SizedBox(height: 10,),
                  Container(
                     padding: EdgeInsets.symmetric(vertical: 20),
                     width: double.infinity,
                    child: RaisedButton(
                        onPressed: () {
                          signup();
                        },
                             padding: EdgeInsets.all(18),
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                             ),
                             color: Colors.orangeAccent.shade700,
                             child: Text(
                             'Sign Up',
                             style: TextStyle(
                             color: Colors.black,
                               fontSize: 18,
                              fontWeight: FontWeight.bold
                               ),
                          )
                       ),
                  ),
                   ],
                 ), ),
               ),       
             ],
             )
         ),
       )
     );
}

_decoration(){
  return BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.centerLeft,
        colors: [
                       Color(0xff0277bd),
                       Color(0xffe1f5fe),
                       Color(0xff4fc3f7),
        ])
    );
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
              Text('User already Register'),
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
signup(){
   _passwordController.text == _passwordConfirmController.text
          ?  _emailController.text.isNotEmpty &&
             _passwordConfirmController.text.isNotEmpty &&
             _nameController.text.isNotEmpty
            ? _register()
            : showMyDialog('Please fill the desired fields')
          : showMyDialog('Password doesn\'t match');
}
  void _register() async {
         showDialog(
        context: context,
        builder: (con) {
        return Center(child: CircularProgressIndicator());
        });
     try{
     var userNew = await authc.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
      );
     var em = userNew.user.email;
     var uid = userNew.user.uid;
    
     if (userNew.additionalUserInfo.isNewUser == true) {
      print('true satisfied');
      writeDataToDataBase(em,uid).then((s) {
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
        _mobileController.clear();
        _passwordController.clear();
        _passwordConfirmController.clear();
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (_) => MyBody());
        Navigator.pushReplacement(context, newRoute);
      });
    }       
     } catch (e) {
       print('new user error');
       print(e.toString());
       showMyDialog(e.toString());

     }
 
  }

  Future writeDataToDataBase(em,uid) async {
    print(uid);
    print(em);
    print(_mobileController.text);
    print(Mn.collectionUser);
    try {
         fsconnect
        .collection('userdata')
        .doc(uid)
        .set({
      Mn.userMobile: _mobileController.text, 
      Mn.userUID: uid,
      Mn.userEmail: em,
      Mn.userName: _nameController.text,
    });
    print('collection');
    
    await Mn.sharedPreferences.setString(Mn.userUID, uid);
    await Mn.sharedPreferences.setString(Mn.userEmail,em);
    await Mn.sharedPreferences.setString(Mn.userName, _nameController.text);
    await Mn.sharedPreferences.setString(Mn.userMobile, _mobileController.text);
    await Mn.sharedPreferences.setString('emotion', '');
    } catch (e) {
      print('writedatabse error');
       print(e);
       showMyDialog(e);
    }
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
}
