import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration successful!')),
              );
              // Navigate to home screen after successful registration
              // Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              // router.go(AppRoutes.dashboard);
              // Navigator.pushNamed(context, '/sign-in');
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SignUpCubit>().signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
                    child: Text('Sign Up'),
                  ),
                  if (state is SignUpLoading)
                    Center(child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed(AppRoutes.signIn);
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