import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    // Choose the appropriate URL based on platform
    String baseUrl;
    if (kIsWeb) {
      // For web apps running in browsers
      baseUrl = 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      // For Android emulators
      baseUrl = 'http://10.0.2.2:8080/api';
    } else {
      // For iOS and other platforms
      baseUrl = 'http://localhost:8080/api';
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        validateStatus: (status) {
          // Accept all status codes so we can handle them manually
          return true;
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      debugPrint('POST request to $path with data: $data');
      return await _dio.post(path, data: data);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      debugPrint('GET request to $path with params: $queryParameters');
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(dynamic error) {
    if (error is DioException) {
      debugPrint('DioError: ${error.message}');
      if (error.response != null) {
        debugPrint('Error Status: ${error.response?.statusCode}');
        debugPrint('Error Response: ${error.response?.data}');
      }
    } else {
      debugPrint('Unexpected error: $error');
    }
  }
}
