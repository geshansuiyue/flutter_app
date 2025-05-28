import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import './http_client.dart'; // 导入HttpClient类

enum RequestMethod { get, post, put, delete, patch }

class Request {
  // 使用静态实例变量而不是每次创建新实例
  static final Dio _dio = HttpClient().dio;

  // 通用请求方法
  static Future<dynamic> request(
    String path, {
    RequestMethod method = RequestMethod.get,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      Response response;

      // 根据请求方法调用不同的Dio方法
      switch (method) {
        case RequestMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case RequestMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case RequestMethod.put:
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case RequestMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case RequestMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
      }

      // 这里可以根据后端的返回格式进行统一处理
      return response.data;
    } on DioException catch (e) {
      // 统一处理错误
      _handleError(e);
      rethrow;
    }
  }

  /// 错误处理
  static void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        debugPrint('连接超时');
        break;
      case DioExceptionType.sendTimeout:
        debugPrint('请求超时');
        break;
      case DioExceptionType.receiveTimeout:
        debugPrint('响应超时');
        break;
      case DioExceptionType.badResponse:
        debugPrint('响应错误: ${e.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        debugPrint('请求取消');
        break;
      case DioExceptionType.unknown:
        debugPrint('其他错误: ${e.message}');
        break;
      case DioExceptionType.connectionError:
        debugPrint('连接错误: ${e.message}');
        break;
      case DioExceptionType.badCertificate:
        debugPrint('证书验证失败: ${e.message}');
        break;
    }
  }

  /// 快捷方法：GET请求
  static Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      path,
      method: RequestMethod.get,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 快捷方法：POST请求
  static Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      path,
      method: RequestMethod.post,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 快捷方法：PUT请求
  static Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      path,
      method: RequestMethod.put,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// 快捷方法：DELETE请求
  static Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return request(
      path,
      method: RequestMethod.delete,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
