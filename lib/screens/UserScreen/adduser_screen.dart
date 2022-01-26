import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebutler/Services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


class AddUser extends StatefulWidget {
  const AddUser({key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _auth = FirebaseAuth.instance; // authentication
  final _formkey = GlobalKey<FormState>(); //formkey
  final TextEditingController nameController =
      new TextEditingController(); //controller
  final TextEditingController emailController =
      new TextEditingController(); //controller
  final TextEditingController passwordController =
      new TextEditingController(); //controller
  final TextEditingController confirmPasswordController =
      new TextEditingController(); //controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Add User", style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(-5, 0),
                blurRadius: 15,
                spreadRadius: 3)
          ]),
          width: double.infinity,
          height: 300,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 240,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        autofocus: false,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.poppins(),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: "Name"),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{3,}$');

                          if(value.isEmpty){
                            return ("Name is required");
                          }

                          if(!regex.hasMatch(value)){
                            return ("Enter valid first name(Min. 3 Characters)");
                          }
                        },
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: "Email"),
                        validator: (value) {
                          RegExp regex = new RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (value.isEmpty) {
                            return ("Email is required");
                          }

                          if (!regex.hasMatch(value)) {
                            return ("Please Enter a valid Email");
                          }

                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value;
                        },
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(hintText: "Password"),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');

                          if (value.isEmpty) {
                            return ("Password is required");
                          }

                          if (!regex.hasMatch(value)) {
                            return ("Enter valid password(Min. 6 Characters)");
                          }

                          return null;
                        },
                        onSaved: (value) {
                          passwordController.text = value;
                        },
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (passwordController.text != value) {
                            return ("Password don't match !");
                          }
                        },
                        onSaved: (value) {
                          confirmPasswordController.text = value;
                        },
                        textInputAction: TextInputAction.done,
                        decoration:
                            InputDecoration(hintText: "Confirm Password"),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 250,
                width: 210,
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: MaterialButton(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.blue[900],
                  child: Text(
                    "Add User",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async{
                    // if(_formkey.currentState.validate() == true){
                    //   try {
                    //     AuthenticationService.signUp(emailController.text, passwordController.text).then((value) async {
                    //       FirebaseUser user = await _auth.currentUser();

                    //       await Firestore.instance.collection("users").document(user.uid).setData({
                    //         'uid': user.uid,
                    //         'email': emailController.text,
                    //         'name': nameController.text,
                    //         'password': passwordController.text,
                    //       });
                    //       _formkey.currentState.reset();
                    //       Scaffold.of(context).showSnackBar(SnackBar(content: Text("Account created successfully!")));
                    //     });
                    //   } catch (signUpError) {
                    //     if(signUpError is PlatformException){
                    //       if(signUpError == "ERROR_EMAIL_ALREADY_USE"){
                    //         Fluttertoast.showToast(msg: "Email already exists!");
                    //       }else if(signUpError == "ERROR_INVALID_EMAIL"){
                    //         Fluttertoast.showToast(msg: "Email invalid!");
                    //       }else if(signUpError == "ERROR_WEAK_PASSWORD"){
                    //         Fluttertoast.showToast(msg: "Password is weak!");
                    //       }
                    //     }
                    //   }
                    // }else if(_formkey.currentState.validate() == false){
                    //   Fluttertoast.showToast(msg: "Make sure there's no error in every field!");
                    // }
                    if (_formkey.currentState.validate() == true) {
                      AuthenticationService.signUp(
                          emailController.text, passwordController.text).then((value) async {
                            FirebaseUser user = await _auth.currentUser();


                            await Firestore.instance.collection("users").document(user.uid).setData({
                              'uid': user.uid,
                              'email': emailController.text,
                              'name': nameController.text,
                              'password': passwordController.text,
                            });
                            // _formkey.currentState.reset();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created successfully!"), backgroundColor: Colors.greenAccent, ));
                          });
                    } else if (_formkey.currentState.validate() == false) {
                      Fluttertoast.showToast(
                          msg: "Make sure everything theres no error !");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
