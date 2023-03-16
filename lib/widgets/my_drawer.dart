// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:section9_35_sluic_ua/splashScreen/splash_screen.dart';

import '../global/global.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;
  String? phone;

  MyDrawer({this.name, this.email, this.phone});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //// drawer header
          Container(
            height: 165,
            color: Colors.grey,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      ////display phone instead of email
                      //// if required you can add email after this Row widget

                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 24,
                            color: Colors.blueGrey,
                          ),

                          SizedBox(width: 12,),

                          Text(
                            userModelCurrentInfo!.phone!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ////you can add email here if required
                    ],
                  ),
                ],
              ),
            ),
          ),

          //// drawer body
          SizedBox(
            height: 12,
          ),

          //// drawer body

          SizedBox(height: 10,),

          GestureDetector(
            onTap: ()
            {

            },
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white54,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {

            },
            child: ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white54,
              ),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {

            },
            child: ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white54,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              fAuth.signOut();
              SystemNavigator.pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            child: ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: Colors.white54,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
