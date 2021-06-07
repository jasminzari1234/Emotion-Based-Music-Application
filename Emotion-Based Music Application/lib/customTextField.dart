import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
   CustomTextField({Key key, this.controller, this.data, this.hintText,this.isObsecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.fromLTRB(5,0,5,0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 6,
              offset: Offset(0, 2),

            )
          ]
        ),
        height: 60,
        child: TextField(
          controller: controller,
          obscureText: isObsecure,
          style: TextStyle(
               color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top:14),
            prefixIcon: Icon(
              data,
              color:Color(0xff5ac18e)
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black45,
            )
          ),
        ),
      );
  }
}