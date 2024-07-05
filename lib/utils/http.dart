import 'dart:convert';
import 'package:dio/dio.dart';
import '../storage/shared_preference.dart';
import 'env.dart';

class HttpUtils {
  static final BaseOptions baseOptions = BaseOptions(
    baseUrl: Env().get("API_HOST"),
    connectTimeout: const Duration(seconds: 2),
    receiveTimeout: const Duration(seconds: 2),
  );

  static final Dio dio = Dio(baseOptions);

  // 封装GET请求
  static Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    Object? token = await SharedPrefer.getJwtToken();
    var headers = {
      'Authorization': token.toString(),
    };
    try {
      var response = await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      return jsonDecode(response.toString());
    } on DioException catch (e) {
      // 处理错误
      print(e.message);
      var err = Map();
      err["code"] = -1;
      err["message"] = "服务器繁忙";
      return jsonDecode(err.toString());
    }
  }

  // 封装POST请求
  static Future<Map<String, dynamic>> post(String path,
      {data, Options? options}) async {
    Object? token = await SharedPrefer.getJwtToken();
    var headers = {
      'Authorization': token.toString(),
    };
    try {
      var response =
          await dio.post(path, data: data, options: Options(headers: headers));
      return jsonDecode(response.toString());
      ;
    } on DioException catch (e) {
      // 处理错误
      print(e.message);
      var err = Map();
      err["code"] = -1;
      err["message"] = "服务器繁忙";
      return jsonDecode(err.toString());
    }
  }
}
