import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_delivery/Screen/login.dart';
import 'package:order_delivery/Utility/custom_list_tile.dart';
import 'package:order_delivery/View/acceptedOrderView.dart';
import 'package:order_delivery/View/assignedOrderView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  void loggedOut() {
    AlertDialog alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content: new Text("Are you sure, You want to log out?"),
      actions: <Widget>[
        new ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.pinkAccent)))),
          child: new Text(
            "Yes",
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: () {
            logOuts(context);
/*            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new LoginPage(),
            ));*/
          },
        ),
        new ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white70)))),
          child: new Text(
            'Cancel',
            style: TextStyle(color: Colors.pink),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  logOuts(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white54,
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.pink,
                Colors.purple,
              ],
            )),
            child: ListView(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://image.shutterstock.com/image-vector/vector-isolated-illustration-delivery-motorcycle-260nw-1901176549.jpg'),
                  radius: 75,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(55, 10, 10, 10),
                  child: Text(
                    'UG Bazaar | Orders',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white70),
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  thickness: 1,
                ),
                SizedBox(height: 20),
                CustomListTile(
                  Icons.house,
                  'Home',
                  () => {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => Orders()))
                  },
                ),
                CustomListTile(
                  Icons.person,
                  'Profile',
                  () => {
                    /*Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => UserProfile()))*/
                  },
                ),
                CustomListTile(
                  Icons.logout,
                  'Logout',
                  () => {loggedOut()},
                )
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          title: new Text(
            "UG BAZAAR | Orders",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          /*leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),*/
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Orders()));
              },
              icon: Icon(Icons.refresh),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.purple],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(Icons.notifications_none),
                text: 'Assigned Orders',
              ),
              Tab(
                icon: Icon(Icons.mood),
                text: 'Accepted Orders',
              ),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: [AssignedOrders(), AcceptedOrders()],
        ),
      ),
    );
  }

  Widget buildPage(String text) => Center(
        child: Text(text, style: TextStyle(fontSize: 28)),
      );
}
