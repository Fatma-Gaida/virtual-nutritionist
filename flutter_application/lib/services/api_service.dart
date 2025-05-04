
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio dio;

  ApiService() : dio = Dio() {
    // For Android emulator
    dio.options.baseUrl = 'http://10.0.2.2:8080/api';
    // Uncomment if using iOS simulator
    // _dio.options.baseUrl = 'http://127.0.0.1:8080/api';
    // Uncomment if using physical device (replace with your computer's IP)
    // _dio.options.baseUrl = 'http://192.168.1.X:8080/api';


 
    if (kIsWeb) {
      // For web apps running in browsers
      dio.options.baseUrl = 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      // For Android emulators
      dio.options.baseUrl = 'http://10.0.2.2:8080/api';
    } else {
      // For iOS and other platforms
      dio.options.baseUrl = 'http://localhost:8080/api';
    }
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add comprehensive logging
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('DIO: $obj'),
      ),
    );
  }

  Future<Response> get(String path) async {
    try {
      print('Sending GET request to: ${dio.options.baseUrl}$path');
      final response = await dio.get(path);
      print('GET response status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('GET request failed: $e');
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      print('Sending POST request to: ${dio.options.baseUrl}$path');
      print('POST data: $data');

      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('POST response status: ${response.statusCode}');
      print('POST response headers: ${response.headers}');
      print('POST response data: ${response.data}');

      return response;
    } catch (e) {
      print('POST request failed: $e');
      if (e is DioException && e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      }
      throw _handleError(e);
    }
  }

   Future<Response> put(String path, dynamic queryParameters) async {
  try {
    // Convert query parameters to Map<String, dynamic>
    final Map<String, dynamic>? safeParams = queryParameters?.map<String, dynamic>(
      (key, value) => MapEntry(key.toString(), value),
    );

    // Log the request URL before sending
    final stringQueryParams = safeParams?.map(
      (key, value) => MapEntry(key, value.toString())
    );

    final uri = stringQueryParams != null
        ? Uri.parse('${dio.options.baseUrl}$path').replace(queryParameters: stringQueryParams)
        : Uri.parse('${dio.options.baseUrl}$path');
    
    print('Constructed PUT request URL: $uri');
    final response = await dio.put(path, queryParameters: safeParams);
    print('PUT request URL (after response): ${response.requestOptions.uri}');
    return response;
  } catch (e) {
    print('PUT request error: $e');
    throw Exception('PUT request failed: $e');
  }
}


    Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } catch (e) {
      throw _handleError(e);
    }
  }



  Future<bool> testConnection() async {
    try {
      print('Testing connection to: ${dio.options.baseUrl}');

      // Try a simple request to the base URL or a health endpoint
      final response = await dio.get(
        '/', // or '/health' if you have such an endpoint
        options: Options(
          validateStatus: (status) => true, // Accept any status
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      print('Connection test status code: ${response.statusCode}');
      return response.statusCode != null && response.statusCode! < 500;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      print('DioError type: ${error.type}');
      print('DioError message: ${error.message}');

      if (error.response != null) {
        print('Error response status: ${error.response?.statusCode}');
        print('Error response data: ${error.response?.data}');

        // Return more specific error based on status code
        if (error.response?.statusCode == 401) {
          return Exception('Invalid email or password');
        } else if (error.response?.statusCode == 404) {
          return Exception('API endpoint not found');
        } else if (error.response?.statusCode != null) {
          return Exception(
            'Server error: ${error.response?.statusCode} - ${error.response?.data}',
          );
        }
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (error.type == DioExceptionType.connectionError) {
        return Exception(
          'Cannot connect to server. Please check your network connection.',
        );
      }

      return Exception('Network error: ${error.message}');
    }

    return Exception('An unexpected error occurred: $error');
  }




  Future<Response> getUserById(String userId) async {
    try {
      return await dio.get('/users/$userId');
    } catch (e) {
      throw _handleError(e);
    }
  }
}


/*
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio dio;
  
  final String baseUrl = 'http://localhost:8080'; // For Android emulator
  // Use 'http://localhost:8080' for iOS simulator
  // Use your actual IP address when testing on physical devices

  ApiService() : dio = Dio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    // Add logging interceptor for debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

/*
  // Helper method for GET requests
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      debugPrint('GET request failed: $e');
      rethrow;
    }
  }
*/
    Future<Response> get(String path) async {
    try {
      print('Sending GET request to: ${dio.options.baseUrl}$path');
      final response = await dio.get(path);
      print('GET response status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('GET request failed: $e');
      throw _handleError(e);
    }
  }

/*
  //this method is from claude ///new code
  // Helper method for POST requests
  Future<Response> post(String path, {Object? data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      debugPrint('POST request failed: $e');
      rethrow;
    }
  }
  */

//this post method is going to accesp more than two parameters (for the login post it is going to accept email and password)
  // Helper method for POST requests
    Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      print('Sending POST request to: ${dio.options.baseUrl}$path');
      print('POST data: $data');

      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('POST response status: ${response.statusCode}');
      print('POST response headers: ${response.headers}');
      print('POST response data: ${response.data}');

      return response;
    } catch (e) {
      print('POST request failed: $e');
      if (e is DioException && e.response != null) {
        print('Error response status: ${e.response?.statusCode}');
        print('Error response data: ${e.response?.data}');
      }
      throw _handleError(e);
    }
  }
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      print('DioError type: ${error.type}');
      print('DioError message: ${error.message}');

      if (error.response != null) {
        print('Error response status: ${error.response?.statusCode}');
        print('Error response data: ${error.response?.data}');

        // Return more specific error based on status code
        if (error.response?.statusCode == 401) {
          return Exception('Invalid email or password');
        } else if (error.response?.statusCode == 404) {
          return Exception('API endpoint not found');
        } else if (error.response?.statusCode != null) {
          return Exception(
            'Server error: ${error.response?.statusCode} - ${error.response?.data}',
          );
        }
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (error.type == DioExceptionType.connectionError) {
        return Exception(
          'Cannot connect to server. Please check your network connection.',
        );
      }

      return Exception('Network error: ${error.message}');
    }

    return Exception('An unexpected error occurred: $error');
  }



  // Helper method for PUT requests
  Future<Response> put(String path, {Object? data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      debugPrint('PUT request failed: $e');
      rethrow;
    }
  }

  // Helper method for DELETE requests
  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      debugPrint('DELETE request failed: $e');
      rethrow;
    }
  }




  /******************** */
    Future<bool> testConnection() async {
    try {
      print('Testing connection to: ${dio.options.baseUrl}');

      // Try a simple request to the base URL or a health endpoint
      final response = await dio.get(
        '/', // or '/health' if you have such an endpoint
        options: Options(
          validateStatus: (status) => true, // Accept any status
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      print('Connection test status code: ${response.statusCode}');
      return response.statusCode != null && response.statusCode! < 500;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

}
*/