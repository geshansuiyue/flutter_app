import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  late Dio _dio;

  HttpClient._internal() {
    // 基础配置
    BaseOptions options = BaseOptions(
      baseUrl: "http://172.31.0.1:3000", // 替换为你的API基础URL
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
              'MUSIC_A_T=1439216540008; MUSIC_R_T=1439216552542; NMTID=00OenDQRfP8TAXtGkS8pku7qDz1JU0AAAGW8Icsmw; _iuqxldmzr_=32; _ntes_nnid=fbb600ff1a9feb345df11f01f4a0e7b5,1747792251511; _ntes_nuid=fbb600ff1a9feb345df11f01f4a0e7b5; WEVNSM=1.0.0; WNMCID=qsgfxz.1747792254162.01.0; _ntes_origin_from=; JSESSIONID-WYYY=8i1HGlaE%2B1GRWq5vS2Jd81ulOkhzIilG7xZHS9j3pnpKzws87QuRPdfH%2FmwN33AZOUhFncYEc8wNSipM4Wh2SNzC5tR0IPRYiIbeVu1HEcu0eavTNEEFIM7iiSrmmdmG9DaRGXcvTsWYdDCFaoE5aqzY5bMbMztn2iAhDrqNMIVKUQWf%3A1748500554885; sDeviceId=YD-noqVjBRWL5RBE1EQQUPSOhbMzCKbghuu; NTES_YD_SESS=WUqR4AuffUIwv8ycVu.FqTF8asZesEXRAynRJWUBi06k2wCz2RvHFKAsIQ3JMjWmX6XgaIbB6HNpRt1RdLo4fguIUYm4B_9dckw8jQQ88ok2HGDexA5XGGKLC30DN6z0AgCz6IY5alKk5NyojTzOSPWdyaCQoUhZSi7qoPBxSlxUq0BLDjV7HbpXAoPNr6MrOuJXyrWN5SyfYMQOWVjU.WX5EbBA6iIHw_5DdXe6f8BoA; S_INFO=1748498864|0|0&60##|15879766054; P_INFO=15879766054|1748498864|1|music|00&99|null&null&null#gud&440100#10#0|&0||15879766054; __csrf=91da42bbdbb14c50a766d43a08bdb9b7; MUSIC_U=005293B5BB308C5CF1D0077D28F5001ACE2DA55308DA7AD77C057D30DAE63B9EBCCE98DB61451B3C0D8657FA5E51649F4EA5CF0AB908767A379E9A9A6B1B773FE935AFB2B2F30FB28FE0D35FE889ACFDAF49BC1ED813084A7214D24DD2BD10002D4DF430ED336FC5A31F758843A416DA53542101267D140D00D57C7ED93DBBFEB6574211E663BBB41A2B22A2C2F001D4B2FF6958046B3E8BBC50CB85E25BA8791436EF506F3BD1DB6CE33027A628568CDF352E6B58FE9E4C8D3029A4AA41C0A760439A3083BAA8101786FDD6FE9BC90A8B81862D6E0C506F535640B864AD68F86AB90C72BDFFED6439F49C93C5D02AB9D9CF0E908D84765E0C5D72610A41852F97DBC4DF3BF4C429FF4570F91919F3F36A5CCE6D46565D9802053E02ABD7784A67F1356B5568069B6DC6D5CF562CB3BAE4B5547804988B03C751E2875830ED6FE5BE686FE310F8381F92880DD2CB6EEA53C850FA5CD89252566B70D244A2582DDF; ntes_kaola_ad=1';
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
