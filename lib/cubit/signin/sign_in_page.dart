import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'package:medmap/views/submenu.dart';
import 'sign_in_cubit.dart';

class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.go(AppRoutes.submenu);
            } else if (state is SignInError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.message),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            final logo = Hero(
              tag: 'logo',
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
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5.0,
                  side: BorderSide.none,
                  padding: EdgeInsets.all(12.0),
                ),
                onPressed: () {
                  String emailValue = emailController.text;
                  String passwordValue = passwordController.text;
                  context.read<SignInCubit>().signIn(emailValue, passwordValue);
                },
                child: Text('Log In', style: TextStyle(fontSize: 18)),
              ),
            );

            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  if (state is SignInLoading) CircularProgressIndicator() else logo,
                  SizedBox(height: 48.0),
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}