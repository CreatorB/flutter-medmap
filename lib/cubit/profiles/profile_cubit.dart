import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:medmap/const.dart';
import 'package:medmap/cubit/profiles/profile_state.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';
import 'dart:io';


class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio;

  ProfileCubit()
      : _dio = Dio(BaseOptions(
            validateStatus: (status) => [200, 422].contains(status))),
        super(ProfileLoading());

  Future<void> fetchProfile() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final role = await Utils.getSpString(Const.ROLE);
      if (role == null) {
        emit(ProfileError('Role is missing.'));
        return;
      }
      late String url = Const.URL_API + "/" + role + '/profile';
      // print("cekProfileUrl: ${url}");
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print("cekProfile: ${response.data}");

      if (response.statusCode == 200) {
        final rProfile profile = rProfile.fromJson(response.data);
        emit(ProfileLoaded(profile));
      } else {
        final errorData = response.data;
        final errorMessage = errorData['message'] ?? 'Failed to get profile.';
        emit(ProfileError(errorMessage));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
    File? image,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final role = await Utils.getSpString(Const.ROLE) ?? "manufacturer";
      late String url = Const.URL_API + "/" + role + '/profile';

      final formData = FormData();

      if (name != null && name.isNotEmpty) {
        formData.fields.add(MapEntry('name', name));
      }
      if (currentPassword != null && currentPassword.isNotEmpty) {
        formData.fields.add(MapEntry('current_password', currentPassword));
      }
      if (newPassword != null && newPassword.isNotEmpty) {
        formData.fields.add(MapEntry('new_password', newPassword));
      }
      if (confirmNewPassword != null && confirmNewPassword.isNotEmpty) {
        formData.fields
            .add(MapEntry('confirm_new_password', confirmNewPassword));
      }
      if (image != null) {
        formData.files.add(MapEntry('logo',
            await MultipartFile.fromFile(image.path, filename: 'logo')));
      }

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("cekUpdateProfile: ${response.toString()}");

      if (response.statusCode == 200) {
        final rProfile profile = rProfile.fromJson(response.data);
        Utils.setProfile(profile);
        emit(ProfileUpdateSuccess(profile));
      } else {
        final errorData = response.data;
        final errorMessage =
            errorData['message'] + errorData['errors'].toString() ??
                'Failed to update profile.';
        emit(ProfileError(errorMessage));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
