import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_library/search.dart';

import 'database/postgresDatabase.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String username = "";
  String password = "";

  void _setText() {
    setState(() {
      username = usernameTextController.text;
      password = passwordTextController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Login Page",
              style: TextStyle(color: Colors.black, fontSize: 25),),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:40,bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
                controller: usernameTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: passwordTextController,
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _setText();
                  PostgresDatabase().checkValidUser(username, password).then((validUser) {
                    if(validUser) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Search()));
                    }
                  });
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}