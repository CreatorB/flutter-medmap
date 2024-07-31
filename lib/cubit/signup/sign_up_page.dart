import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Registration Successful'),
                      content: Text("Please check your email for verification."),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            context.go(AppRoutes.home);
                          },
                        ),
                      ],
                    );
                  },
                );
            } else if (state is SignUpFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.error),
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Hero(
                    tag: 'logo-medmap',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset('assets/icons/ic_launcher.png'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select User Type',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                    ),
                    items: <String>['Manufacturer', 'Distributor', 'Healthcare']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      role = newValue!;
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                  child : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5.0,
                      side: BorderSide.none,
                      padding: EdgeInsets.all(12.0),
                    ),
                    onPressed: () {
                      context.read<SignUpCubit>().signUp(
                            _emailController.text,
                            _passwordController.text,
                            _usernameController.text,
                            role?.toLowerCase() ?? 'manufacturer',
                          );
                    },
                    child: Text('Sign Up'),
                  ),
                  ),
                  if (state is SignUpLoading)
                    Center(child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.go(AppRoutes.signIn);
                    },
                    child: Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
