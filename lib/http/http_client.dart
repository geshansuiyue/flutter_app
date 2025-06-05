import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  late Dio _dio;

  HttpClient._internal() {
    // 基础配置
    BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.2.24:3000", // 替换为你的API基础URL
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
          options.headers['cookie'] =
              'MUSIC_U=0041BDCD087B36B4D9382893720887117F8DE7CBC7F0F901794DA80C649D6DA760D0482B8D33EABE6DCFCA7DC36090E1D33E99DF3381303441EF11AACA6AC82637E52B9EA331EBA185F9A7D91C4640A90C484DF2599550A60A7605E9FA1E53D25D65F7D638CA543DC0CB9C8C29D33690B87F7C3A291BE5935F458D590C27F70B88DD95D0C7C99D77EAA3FC02E67D5EA763DBE418FDF4F786AB560A51447ED99D80541174770655A8184F6278E0B92EA16CFEAD4183018941D97266B21E514651AB0CE60B5BC61C8C14F19E0F2A45C823FB0CAC564B8AFC56DE05159C5E24CA88C98C9925A89DB7A7276D571E286458423226154072E2346BEDC41A5453E77FDA014E29F516A6FBFE880C696D8C41698E6514B9C73DF9E07B486D3C66EA1194005ADB47D5732182A50551C5FE0CC7133C0AA3076FDBDD1A5BDB91DF9E3C1E6E38098E474A3D5ECD3940FB230748C6BC2EEB; ntes_utid=tid._.uSke36p6pAVEA1EVQAeWah%252Fsslew9n63._.0';
          if (kDebugMode) {
            print('请求URL: ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('响应数据: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
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
