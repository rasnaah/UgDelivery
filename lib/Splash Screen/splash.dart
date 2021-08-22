import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:order_delivery/Screen/login.dart';
import 'package:order_delivery/Screen/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashDisplay extends StatefulWidget {
  final Color backgroundColor;
  final dynamic onClick;
  SplashDisplay({this.onClick, this.backgroundColor = Colors.white});

  static const String id = 'splash_page';

  @override
  _SplashDisplayState createState() => _SplashDisplayState();
}

class _SplashDisplayState extends State<SplashDisplay> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
/*    Timer(Duration(seconds: 5), () {
      // It's fairly safe to assume this is using the in-built material
      // named route component
      checkLoginStatus();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()));
    });*/
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('BearerToken');
    if (token != null) {
      print('token: $token');
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => Orders()));
    } else {
      print('token: $token');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        onTap: widget.onClick,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: new Container(
                            child: Image.asset(
                              'assets/images/delivery.gif',
                            ),
                          ),
                          radius: 150.0,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          'Welcome to UG BAZAAR',
                          style: new TextStyle(
                            color: Colors.pink[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      Text(
                        'Powered by UG Bazaar',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Acme',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
