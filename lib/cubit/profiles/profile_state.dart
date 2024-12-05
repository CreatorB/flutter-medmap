import 'package:medmap/models/r_profile.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final rProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final rProfile profile;

  ProfileUpdateSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}