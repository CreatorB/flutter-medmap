import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medmap/const.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final RegExp emailRegex =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$');

  Future<void> signIn(String email, String pass) async {
    if (email.isEmpty || !emailRegex.hasMatch(email) || pass.isEmpty) {
      emit(SignInError('Please fill in both Email and Password correctly.'));
      return;
    }

    emit(SignInLoading());

    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    try {
      var response = await dio
          .post(Const.API_LOGIN, data: {"email": email, "password": pass},
              options: Options(validateStatus: (status) {
        return true;
      }));

      if (response.statusCode != 200) {
        emit(SignInError(response.data['message']));
        return;
      }

      Utils.setSpBool(Const.IS_LOGED_IN, true);
      Utils.setSpString(Const.TOKEN, response.data['token']['token']);
      Utils.setSpString(Const.EXPIRES_AT, response.data['token']['expires_at']);
      Utils.setSpString(Const.USERNAME, response.data['user']['username']);

      if (response.data['user']['role'] == 'admin') {
        emit(SignInSuccess());
      } else {
        getUser(response.data['token']['token'], response.data['user']['role']);
      }
    } catch (e) {
      emit(SignInError(e.toString()));
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
        emit(SignInError(response.data['message']));
        return;
      }

      rProfile mData = rProfile.fromJson(response.data);
      Utils.setProfile(mData);
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInError(e.toString()));
    }
  }
}