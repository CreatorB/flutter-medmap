import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
        'title': requestTitle,
        'description': fullDescription,
        'currency': selectedCurrency,
        'budget': estimateBudget,
        'priceType': selectedPriceType,
      });

      for (var i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
          'images',
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

      print("formDataServiceRequest: $formDataString");

      // final response = await _dio.post(
      //   'https://your-api-endpoint.com/service-requests',
      //   data: formData,
      //   options: Options(
      //     headers: {
      //       'Content-Type': 'multipart/form-data',
      //     },
      //   ),
      // );

      // if (response.statusCode == 201) {
      //   emit(ServiceRequestLoaded());
      // } else {
      //   throw Exception('Failed to create service request.');
      // }
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }
}
