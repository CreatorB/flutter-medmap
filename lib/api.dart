import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'const.dart';
import 'utils.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class Api {
  final String baseUrl = Const.URL_API;
  HttpClientWithMiddleware _client =
      HttpClientWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  // Example: GET request
  Future<dynamic> fetchData(BuildContext context, String endpoint) async {
    String apiUrl = '$baseUrl/$endpoint';
    // print(apiUrl);
    try {
      final response = await _client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handle the error, you can create a custom error response here
        // return Future.error("Error: ${response.statusCode}");
        Utils.showSnackBar(context, 'Failed to load data');
      }
    } catch (e) {
      // return Future.error(e.toString());
      Utils.showSnackBar(context, e.toString());
    }
  }

  // Example: POST request
  Future<dynamic> postData(
      BuildContext context, String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return json.decode(response.body);
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        Utils.showSnackBar(context, 'Failed to load data');
        // throw Exception('Failed to post data');
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }
}
