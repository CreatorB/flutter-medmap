import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medmap/cubit/profiles/profile_cubit.dart';
import 'package:medmap/cubit/profiles/profile_state.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/route/app_routes.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit()..fetchProfile(),
        child: ProfileView(),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  File? _image;
  rProfile? _cachedProfile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          if (state.message == 'Role is missing.') {
            context.go(AppRoutes.signIn);
          }
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileUpdating) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
          final profile = state is ProfileLoaded
              ? state.profile
              : (state as ProfileUpdateSuccess).profile;
          _cachedProfile = profile; // Simpan profil yang sudah ada
          _nameController.text = profile.name ?? '';

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : NetworkImage(profile.logo?.url ?? '')
                                as ImageProvider,
                        radius: 50,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    initialValue: profile.user.email,
                    decoration: InputDecoration(labelText: 'Email'),
                    enabled: false,
                  ),
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: InputDecoration(labelText: 'Current Password'),
                    obscureText: true,
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    decoration:
                        InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileCubit>().updateProfile(
                                name: _nameController.text,
                                currentPassword:
                                    _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                                confirmNewPassword:
                                    _confirmNewPasswordController.text,
                                image: _image,
                              );
                        }
                      },
                      child: Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileError) {
          // Gunakan profil yang sudah ada sebelum error
          if (_cachedProfile != null) {
            final profile = _cachedProfile!;
            _nameController.text = profile.name ?? '';

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : NetworkImage(profile.logo?.url ?? '')
                                  as ImageProvider,
                          radius: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      initialValue: profile.user.email,
                      decoration: InputDecoration(labelText: 'Email'),
                      enabled: false,
                    ),
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      decoration:
                          InputDecoration(labelText: 'Confirm New Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().updateProfile(
                                  name: _nameController.text,
                                  currentPassword:
                                      _currentPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                  confirmNewPassword:
                                      _confirmNewPasswordController.text,
                                  image: _image,
                                );
                          }
                        },
                        child: Text('Update'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}