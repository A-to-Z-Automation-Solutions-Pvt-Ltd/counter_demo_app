import 'dart:async';

import 'package:flutter/material.dart';
import 'package:section9_35_sluic_ua/global/global.dart';

import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../mainScreens/main_screen.dart';


class MySplashScreen extends StatefulWidget {

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen > {

  startTimer()
  {
    fAuth.currentUser != null? AssistantMethods.readCurrentOnlineUserInfo(): null;
    Timer(Duration (seconds: 3), ()async
    {
      if(await fAuth.currentUser != null)
        {
          currentFirebaseUser = fAuth.currentUser;
          ///if user is logged in send user to main-screen
          Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      else
        {
          ///if user is not logged in send user to the login screen
          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }
    });
  }

  @override
  void initState() {

    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left:20,
                    right: 20,),
                child: Image.asset("images/logo.png"),
              ),

              // SizedBox(
              //   height: 1,
              // ),

              Text("Taxi App",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}


