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
              'MUSIC_U=00E6DEA27B8B7E1D173BF6074DD674D62E0F77105D983C71BB11F967FB599FADE283607125927BC577E66018E5AE9678C17776CE1811569B8430DEF35E74939A5B07A2AE543572195FC28907791A0172E80FB55225CC9E7AA34A86FEA010716EDEB769BD7337A109D8DAA40CA316F5FDD44C071F94F40016F9BAF65DE0E36A92F158F6DD8B12D28E76E1988C64B53B9270F6DD45ED9D915FEF9BEFCD8A02F7291A37DE302BEAF362797858EE34738465CD4A529F615DF5D581A0622186DDF91DED2AFAA2A08F9A19324A42C0CDD0232D6A2ADE58993EEEEAD3999C8C38ACF9C55ABAD485097432071DDED6665FBAF5DF0333EDA1566270618439C4FFD3DD8FAAF6CF645BB8EB94D294BB6E2537C9F5861C397E8028EDBB2AACC90D3174A1DA0E5B101D562BA31FFD7473B0B58C3926B0EBA0494705145B97ED2B9A5C403B03C83855FF47509553D8B031A580770779F6FB';
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
