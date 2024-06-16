import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medmap/const.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';
import 'package:medmap/views/submenu.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  static String tag = 'login';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final RegExp emailRegex =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$');

  Future<void> getUser(String token, String role) async {
    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    dio.options.headers["Authorization"] = "Bearer ${token}";
    try {
      var response = await dio.get(Const.URL_API + "/$role/profile",
          options: Options(validateStatus: (status) {
        return true;
      }));

      if (response.statusCode != 200) {
        print("responseMsg: " + response.data['message']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(response.data['message']),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      // DataModel dataModel = DataModel.fromJson(json.decode(jsonString));
      // String serializedJson = json.encode(dataModel.toJson());
      rProfile mData = rProfile.fromJson(response.data);
      Utils.setProfile(mData);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Submenu()),
      );
    } catch (e, stackTrace) {
      print("Errors: " + e.toString());
      print("StackTrace: " + stackTrace.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signIn(String email, String pass) async {
    if (email.isEmpty || !emailRegex.hasMatch(email) || pass.isEmpty) {
      // Show an error if either field is empty or email is invalid
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content:
                  Text('Please fill in both Email and Password correctly.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }

    setState(() {
      isLoading = true;
    });

    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    try {
      var response = await dio
          .post(Const.API_LOGIN, data: {"email": email, "password": pass},
              options: Options(validateStatus: (status) {
        return true;
      }));

      if (response.statusCode != 200) {
        print("responseMsg: " + response.data['message']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(response.data['message']),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      Utils.setSpBool(Const.IS_LOGED_IN, true);
      Utils.setSpString(Const.TOKEN, response.data['token']['token']);
      Utils.setSpString(Const.EXPIRES_AT, response.data['token']['expires_at']);
      Utils.setSpString(Const.USERNAME, response.data['user']['username']);
      if (response.data['user']['role'] == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Submenu()),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Submenu()),
        // );
      } else {
        getUser(response.data['token']['token'], response.data['user']['role']);
      }
    } catch (e, stackTrace) {
      print("Errors: " + e.toString());
      print("StackTrace: " + stackTrace.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/icons/ic_launcher.png'),
      ),
    );

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Background color
          foregroundColor: Colors.white, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ), // Rounded corners
          elevation: 5.0, // Shadow under the button
          side: BorderSide.none, // No border
          padding: EdgeInsets.all(12.0), // Padding around the text
        ),
        onPressed: () {
          String emailValue = emailController.text;
          String passwordValue = passwordController.text;
          signIn(emailValue, passwordValue);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Submenu()),
          // );
        },
        child: Text('Log In', style: TextStyle(fontSize: 18)), // Text style
      ),
    );
    // final forgotLabel = ElevatedButton(
    //   child: Text(
    //     'Forgot password?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization'),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back), // Use the arrow_back icon for the back button
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            if (isLoading) CircularProgressIndicator() else logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            // forgotLabel
          ],
        ),
      ),
    );
  }
}
