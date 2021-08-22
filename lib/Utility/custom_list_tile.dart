import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 0, 8.0, 0),
      child: Container(
        /*decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade400))
        ),*/
        child: InkWell(
          splashColor: Colors.pinkAccent,
          onTap: onTap,
          child: Container(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon, color: Colors.white70),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ), //Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
