import 'package:flutter/material.dart';
import 'package:order_delivery/Screen/orders.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(110, 20, 30, 0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/rolex.jpg'),
                    radius: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Rasana Tamrakar',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'rasna@ugbazaar.com',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[400]),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '9810101010',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[400]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
