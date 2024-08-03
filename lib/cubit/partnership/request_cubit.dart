import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:medmap/const.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';

part 'request_state.dart';

class Country {
  final int id;
  final String name;
  Country.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class States {
  final int id;
  final String name;
  States.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class CountriesLoaded extends RequestState {
  final List<Country> countries;
  CountriesLoaded(this.countries);
}

class StatesLoaded extends RequestState {
  final List<States> states;
  StatesLoaded(this.states);
}

// class RequestState extends StatefulWidget {

//   final int idRequest;

//   const RequestState({required this.idRequest});

//   @override
//   RequestCubit createState() => RequestCubit();
// }

class RequestCubit extends Cubit<RequestState> {
  int? _selectedCountryId;
  int? _selectedStateId;
// Getter untuk mendapatkan state negara dan provinsi/staat
  int? get selectedCountryId => _selectedCountryId;
  int? get selectedStateId => _selectedStateId;

  // Setter untuk mengupdate state negara dan provinsi/staat
  void setSelectedCountryId(int? id) {
    _selectedCountryId = id;
  }

  void setSelectedStateId(int? id) {
    _selectedStateId = id;
  }


  final Dio _dio = Dio();

  RequestCubit() : super(RequestInitial());

  Future<void> fetchCountries() async {
    _dio.interceptors.add(const OmegaDioLogger());
    try {
      final response =
          await _dio.get(Const.URL_API + "/countries?page=1&limit=9999");
      if (response.statusCode == 200) {
        final countries = response.data['data'] as List;
        emit(CountriesLoaded(
            countries.map((c) => Country.fromJson(c)).toList()));
      } else {
        emit(RequestFailure('Failed to load countries'));
      }
    } catch (e) {
      emit(RequestFailure('Failed to load countries: $e'));
    }
  }

  Future<void> fetchStates(int countryId) async {
    _dio.interceptors.add(const OmegaDioLogger());
    try {
      final response = await _dio
          .get(Const.URL_API + "/countries/$countryId/states?page=1&limit=999");
      if (response.statusCode == 200) {
        final states = response.data['data'] as List;
        emit(StatesLoaded(states.map((s) => States.fromJson(s)).toList()));
      } else {
        emit(RequestFailure('Failed to load states'));
      }
    } catch (e) {
      emit(RequestFailure('Failed to load states: $e'));
    }
  }

  Future<void> submitForm(Map<String, dynamic> formData) async {
    print("cekFormData : " + formData.toString());
    // emit(RequestLoading());
    // try {
    //   final response = await _dio.post(
    //     'https://your-api-endpoint.com/submit',
    //     data: formData,
    //   );
    //   if (response.statusCode == 200) {
    //     emit(RequestSuccess(response.data));
    //   } else {
    //     emit(RequestFailure(response.data['message']));
    //   }
    // } on DioError catch (e) {
    //   emit(RequestFailure(e.response?.data?.message));
    // }
  }
}
