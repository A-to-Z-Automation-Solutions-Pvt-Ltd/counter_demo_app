import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:section9_35_sluic_ua/authentication/signup_screen.dart';

import '../global/global.dart';
import '../mainScreens/main_screen.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>

{

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email format is invalid!");
    }
    else if(passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is required");
    }
    else
    {
      loginUserNow();
    }
  }

  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Logging you in. Please wait...",);
        }
    );

    ///authenticate user
    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error:" + msg.toString());
        })
    ).user;

    ///save user/rider details to  Rtdb
    if(firebaseUser != null)
    {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child(
          "users");
      usersRef.child(firebaseUser.uid).once().then((userKey)

      //// assign the userKey to the snapshot
      {
        final snap = userKey.snapshot;
        if (snap.value != null) {
          //// if user/rider record exists lognin the rider/user
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "You are Logged In!");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "No Record found!");
          fAuth.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Sign in failed\n Try again...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [

              SizedBox(height: 30,),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),

              SizedBox(height: 30,),

              Text(
                "Rider Login",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30,),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Email :",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),

              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Password :",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),

              ),

              SizedBox(height: 30,),

              ElevatedButton(
                onPressed: ()
                {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.red),
                  ), backgroundColor: Colors.blueGrey,
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),

              SizedBox(height: 30,),

              ////if not registered this button will send the user to the signup screen
              TextButton(
                child: Text(
                  "Do Not have an Account? Register here",
                  style: TextStyle(color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                onPressed: ()
                {
                  ////go to the signup screen
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SignupScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
