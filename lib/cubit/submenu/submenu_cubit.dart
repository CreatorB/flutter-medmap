import 'package:bloc/bloc.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';

class SubmenuCubit extends Cubit<SubmenuState> {
  SubmenuCubit() : super(SubmenuInitial());

  Future<void> loadProfileData() async {
    emit(SubmenuLoading());
    try {
      var profile = await Utils.getProfile();
      var username = await Utils.getSpString('username');
      emit(SubmenuLoaded(profile: profile, username: username ?? 'Username not set'));
    } catch (e) {
      emit(SubmenuError(message: e.toString()));
    }
  }
}

abstract class SubmenuState {}

class SubmenuInitial extends SubmenuState {}

class SubmenuLoading extends SubmenuState {}

class SubmenuLoaded extends SubmenuState {
  final rProfile? profile;
  final String username;

  SubmenuLoaded({required this.profile, required this.username});
}

class SubmenuError extends SubmenuState {
  final String message;

  SubmenuError({required this.message});
}