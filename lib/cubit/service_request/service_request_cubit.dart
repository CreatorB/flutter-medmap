import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:medmap/const.dart';
import 'package:medmap/utils.dart';
import 'package:meta/meta.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final Dio _dio = Dio();

  ServiceRequestCubit() : super(ServiceRequestInitial());

  Future<void> submitRequest({
    required String requestTitle,
    required String fullDescription,
    required String selectedCurrency,
    required String estimateBudget,
    required String selectedPriceType,
    required List<File> images,
  }) async {
    emit(ServiceRequestLoading());

    try {
      FormData formData = FormData.fromMap({
        'submitter_id': await Utils.getSpString('user_id'),
        'title': requestTitle,
        'description': fullDescription,
        'currency': selectedCurrency,
        'budget': estimateBudget,
        'price_type': selectedPriceType,
      });

      for (var i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(images[i].path,
              filename: 'image_$i.jpg'),
        ));
      }

      String formDataString = "FormData:\n";
      formData.fields.forEach((field) {
        formDataString += "${field.key}: ${field.value}\n";
      });
      formData.files.forEach((file) {
        formDataString += "${file.key}: ${file.value.filename}\n";
      });

      print("cekReqService: $formDataString");

      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        Const.API_SERVICE_REQUESTS,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(ServiceRequestLoaded());
      } else {
        print("failedReqService: $response");
        throw Exception('Failed to create service request.');
      }
    } catch (e) {
      if (e is DioException) {
        print("DioException: ${e.response?.data}");
      } else {
        print("Unhandled Error: $e");
      }
      emit(ServiceRequestError(e.toString()));
    }
  }
}
