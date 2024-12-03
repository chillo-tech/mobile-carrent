import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/utils.dart';
import 'package:logging/logging.dart';

import 'app_exception.dart';
import 'auth_headers.dart';

class ExceptionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // If the response is successful, return it
    if (response.statusCode == 200) {
      var log = Logger("ApiProvider");
      log.info('RESPONSE $response');
      return handler.next(response);
    }

    // Handle specific status codes and throw FetchDataException accordingly
    if (response.statusCode == 408) {
      throw FetchDataException({
        'statusCode': 3,
        'message': 'connection_timedout_error'.tr,
      });
    } else if (response.statusCode == 404) {
      throw FetchDataException({
        'statusCode': 2,
        'message': 'no_internet_error'.tr,
      });
    } else {
      // You can handle other status codes as needed
      return handler.next(response);
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle Dio errors (e.g., SocketException, HttpException)
    if (err.response?.statusCode == 401) {
      final dio = Dio();
      AuthHeaders requestHeaders = new AuthHeaders();
      err.requestOptions.headers.addAll(await requestHeaders.setAuthHeaders());
      return handler.resolve(await dio.fetch(err.requestOptions));
    }
    if (err.error is SocketException) {
      throw FetchDataException({
        'statusCode': 1,
        'message': 'Server not available',
      });
    } else if (err.error is HttpException) {
      throw FetchDataException({
        'statusCode': 2,
        'message': 'no_internet_error'.tr,
      });
    } else {
      // You can handle other Dio errors as needed
      return handler.next(err);
    }
  }
}
