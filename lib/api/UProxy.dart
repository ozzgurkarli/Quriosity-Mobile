// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quriosity/api/ENV.dart';

class UProxy {
  static Future<T> Request<T>(int Type, String route,
      {Map<String, dynamic>? data, String? param}) async {
    UProxy proxy = UProxy();
    final dio = Dio();
    late final response;
    dio.options.validateStatus = (status) {
      return status != null && status < 501;
    };

    try {
      if (Type == 1) {
        response = await proxy.Post(dio, route, data!);
      } else if (Type == 2) {
        response = await proxy.Get(dio, route);
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception("Sunucuya ulaşılamıyor.");
      }
    }

    if (response.statusCode! > 299) {
      throw Exception(response.data);
    }

    return response.data;
  }

  Future<Response> Post(Dio dio, String route, Map<String, dynamic> data) async {
    final url = "${ENV.ConnectionString}$route";
    return await dio.post(url, data: data);
  }

  Future<Response> Get(Dio dio, String route, {String? param}) async {
    final url = "${ENV.ConnectionString}$route/$param";
    return await dio.get(url);
  }
}
