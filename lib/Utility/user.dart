import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_delivery/Controller/databasehelper.dart';
import 'package:order_delivery/Screen/orders.dart';
import 'package:order_delivery/Screen/profile_page.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

//methods for displaying users in user profile
getUsers(context) async {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var currentUser = await databaseHelper.getUserData();
  print(currentUser);
  /*Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => UserProfile(
            currentUser: currentUser,
            */ /*rescueData: userRescue,
            dataLength: userRescue.length,
            list: [
              currentUser['user']['id'],
              currentUser['user']['name'],
              currentUser['user']['email'],
              currentUser['user']['phone'],
              currentUser['user']['password']
            ],*/ /*
          )),
          (Route<dynamic> route) => false);*/
}

//get userid
getUserID(context) async {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var data = await databaseHelper.getUserData();
  print(data);
  var userID = (data['user']['id']);
  print(userID.runtimeType);
  print(userID);
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Orders(
              //userId: userID,
              )),
      (Route<dynamic> route) => false);
}
