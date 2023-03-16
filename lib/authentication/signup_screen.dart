import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:section9_35_sluic_ua/splashScreen/splash_screen.dart';
import 'package:section9_35_sluic_ua/widgets/progress_dialog.dart';

import '../global/global.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
{

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(nameTextEditingController.text.length < 3)
    {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters");
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email format is invalid!");
    }
    else if(phoneTextEditingController.text.isEmpty || phoneTextEditingController.text.length < 10)
    {
      Fluttertoast.showToast(msg: "Phone number should be at least 10 digits");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
    }
    else
    {
      saveUserInfoNow();
    };
  }


  saveUserInfoNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Registering, please wait...",);
        }
    );

    ///save user details to authentication
    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error:" + msg.toString());
        })
    ).user;

    ///save user details to  Rtdb
    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      ////create the parent node "drivers" in the rtdb
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
      userRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created\n Taking you to Car Info Screen...");
      ////send the user to the car_info screen to validate the car details
      Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account creation failed\n Try again...");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Image(
                    image: AssetImage(
                      "images/logo.png",
                    ),
                    width: 350.0,
                    height: 250.0,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  Text(
                    "Rider Signup",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Raleway-Bold"),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1.0,
                        ),

                        ////Text fields for accepting details of the driver
                        TextField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: "raleway-regular"),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        TextField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "raleway-regular"),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        TextField(
                          controller: phoneTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0, fontFamily: "raleway-regular"),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        TextField(
                          controller: passwordTextEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontFamily: "raleway-regular",
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 25.0,
                        ),

                        //// add button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0),
                            ),
                          ),

                          ////for email or phone authentication,  the user can be directed to
                          ////the email or phone authentication page

                          ////this will take us to the vehicle details registration page before
                          ////sending user to the car info screen
                          ///the user may then be redirected to the car_info_screen from the
                          ////authentication page

                          onPressed: ()
                          {
                            validateForm();
                          },
                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Raleway-Black",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////if already registered this button will send the user to the login screen
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                    },
                    child: Text(
                      "Already Registered? Login here",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Raleway-Italic",
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
