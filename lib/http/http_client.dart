import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  late Dio _dio;

  HttpClient._internal() {
    // 基础配置
    BaseOptions options = BaseOptions(
      baseUrl: "https://api.example.com", // 替换为你的API基础URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 添加公共请求头，如Token
          options.headers['Authorization'] = 'Bearer your_token_here';
          if (kDebugMode) {
            print('请求URL: ${options.uri}');
            print('请求头: ${options.headers}');
            print('请求参数: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('响应状态码: ${response.statusCode}');
            print('响应数据: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('请求错误: ${e.message}');
            if (e.response != null) {
              print('错误状态码: ${e.response?.statusCode}');
              print('错误响应: ${e.response?.data}');
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
