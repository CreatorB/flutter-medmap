import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medmap/const.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final RegExp emailRegex =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$');

  Future<void> signUp(String email, String password, String username, String role) async {
    print(email + " " + password + " " + username + " " + role);
    if (email.isEmpty || !emailRegex.hasMatch(email) || password.isEmpty || username.isEmpty || role.isEmpty) {
      emit(SignUpFailure('Please fill in all fields correctly.'));
      return;
    }
    emit(SignUpLoading());

    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    var mUrl = Const.API_REGISTER + role; 
    try {
      var response = await dio
          .post(mUrl, data: {"email": email, "password": password, "username": username},
              options: Options(validateStatus: (status) {
        return true;
      }));

      print(response.data.toString());

      if (response.statusCode != 200) {
        var mError = response.data['errors'][0]['message'] ?? "";
        emit(SignUpFailure(response.data['message'] + " " + mError ));
        return;
      }
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

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
        emit(SignUpFailure(response.data['message']));
        return;
      }

      rProfile mData = rProfile.fromJson(response.data);
      Utils.setProfile(mData);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}