import 'dart:convert';

import 'package:chat_app/helpers/AppConfig.dart';
import 'package:chat_app/helpers/common.dart';
import 'package:chat_app/helpers/style.dart';
import 'package:chat_app/models/JSONResponseModels.dart';
import 'package:chat_app/provider/user.dart';
import 'package:chat_app/screens/admin.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool hidePass = true;
  int isSeller;
  Status _status = Status.Uninitialized;

  int setlectedRadio = 0;

  @override
  void initState() {
    isSeller = 0;
    super.initState();
    AppConfig.getProducts();

  }

  void setSelectedRadio(int val) {
    setState(() {
      isSeller = val;
      print('DEBUG+++++-------$isSeller');
    });
  }

  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<UserProvider>(context);
    return Scaffold(

      key: _key,
      body: user.status == Status.Authenticating
          ? Loading()
          : Stack(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[350],
                            blurRadius:
                                20.0, // has the effect of softening the shadow
                          )
                        ],
                      ),
                      child: Form(
                          key: _formKey,
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      'images/logo.jpg',
                                      width: 260.0,
                                    )),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextFormField(
                                      controller: _email,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        icon: Icon(Icons.alternate_email),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            return 'Please make sure your email address is valid';
                                          else
                                            return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: ListTile(
                                      title: TextFormField(
                                        controller: _password,
                                        obscureText: hidePass,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          icon: Icon(Icons.lock_outline),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "The password field cannot be empty";
                                          } else if (value.length < 6) {
                                            return "the password has to be at least 6 characters long";
                                          }
                                          return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            setState(() {
                                              hidePass = !hidePass;
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          var response = await user.signIn(
                                              _email.text, _password.text);
                                          // _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
                                          Register loginResp =
                                              Register.fromJson(
                                                  json.decode(response.body));

                                          if ((loginResp.status != null) &&
                                              (loginResp.status == 1)) {
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '${loginResp.message}')));

                                            AppConfig().saveToSharedPrefs(
                                                'email', _email.text);
                                            AppConfig().saveToSharedPrefs(
                                                'pass', _password.text);

                                            AppConfig.username = _email.text;
                                            AppConfig.password = _password.text;

                                            if (isSeller == 1) {
                                              changeScreenReplacement(
                                                  context, Admin());
                                            } else {
                                              changeScreenReplacement(
                                                  context, HomePage());
                                            }
                                          } else {
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '${loginResp.message}')));

                                            // _status = Status.Authenticating;

                                            return;
                                          }
                                        }
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Forgot password",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                      },
                                      child: Text(
                                        "Create an account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Seller",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Radio(
                                      value: 1,
                                      groupValue: isSeller,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setSelectedRadio(value);
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Buyer",
                                    style: TextStyle(
                                      color: Colors.green,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Radio(
                                      value: 2,
                                      groupValue: isSeller,
                                      activeColor: Colors.green,
                                      onChanged: (value) {
                                        setSelectedRadio(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),

//                        Padding(
//                          padding: const EdgeInsets.all(16.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text("or sign in with", style: TextStyle(fontSize: 18,color: Colors.grey),),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: MaterialButton(
//                                    onPressed: () {},
//                                    child: Image.asset("images/ggg.png", width: 30,)
//                                ),
//                              ),
//
//                            ],
//                          ),
//                        ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
