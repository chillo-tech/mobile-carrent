// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dioPkg;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http_client;
import 'package:logging/logging.dart' as logg;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import 'ExceptionInterceptor.dart';
import 'app_exception.dart';

class ApiProvider {
  var log = logg.Logger("ApiProvider");
  final contentTypeKey = "Content-Type";

  final useMock = false;

  int connectTimeout = 70; //seconds
  Map<String, String>? _headers = {
    // Constants.API_GATEWAY_KEY: ApiKey.apiGatewayKey,
  };

  Map<String, String>? get headers {
    return _headers;
  }

  set headers(Map<String, String>? headers) {
    if (headers != null) {
      // headers.putIfAbsent(
      //     Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);
    }
    _headers = headers;
  }

  HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  late dioPkg.Dio _dio;
  static final ApiProvider _singleton = ApiProvider._internal();

  factory ApiProvider() {
    return _singleton;
  }

  ApiProvider._internal() {
    initializeDio();
  }

  Future<void> initializeDio() async {
    _dio = dioPkg.Dio(
      dioPkg.BaseOptions(
        connectTimeout: Duration(seconds: connectTimeout),
        // headers: {
        //   // Constants.API_GATEWAY_KEY: ApiKey.apiGatewayKey,
        // },
      ),
    );
    _dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );
    _dio.interceptors.add(ExceptionInterceptor());
    // _dio.addSentry();
  }

  Future<dynamic> get(String baseUrl, String url) async {
    var responseJson;
    log.info(baseUrl + url);
    var callURL = Uri.parse(baseUrl + url);
    final contentTypeHeader =
        _headers?[contentTypeKey] ?? dioPkg.Headers.jsonContentType;
    final response = await _dio.getUri(
      callURL,
      options: dioPkg.Options(headers: headers, contentType: contentTypeHeader),
    );
    responseJson = _returnResponseDio(response);
    return jsonEncode(responseJson);
  }

  Future<dynamic> post(String baseUrl, String url,
      {Map<String, dynamic>? body, String? contentType}) async {
    var responseJson;
    log.info(baseUrl + url);
    var callURL = Uri.parse(baseUrl + url);
    final contentTypeHeader =
        _headers?[contentTypeKey] ?? dioPkg.Headers.jsonContentType;
    final response = await _dio.postUri<dynamic>(
      callURL,
      data: body,
      options: dioPkg.Options(headers: headers, contentType: contentTypeHeader),
    );
    responseJson = _returnResponseDio(response);
    return jsonEncode(responseJson);
  }

  Future<dynamic> postWithHTTP(String baseUrl, String url, dynamic body) async {
    var responseJson;
    try {
      log.info(baseUrl + url);
      var callURL = Uri.parse(baseUrl + url);
      final response = await http
          .post(callURL, body: body, headers: headers)
          .timeout(Duration(seconds: connectTimeout), onTimeout: () {
        throw FetchDataException(
            {'statusCode': 3, 'message': 'Connexion timeout'});
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(
          {'statusCode': 1, 'message': 'Server not available'});
    } on HttpException {
      throw FetchDataException(
          {'statusCode': 2, 'message': 'No internet error'});
    }
    return responseJson;
  }

  Future<dynamic> put(String baseUrl, String url, dynamic body,
      {String? contentType}) async {
    var responseJson;
    log.info(baseUrl + url);
    var callURL = Uri.parse(baseUrl + url);
    final contentTypeHeader =
        _headers?[contentTypeKey] ?? dioPkg.Headers.jsonContentType;
    final response = await _dio.putUri<dynamic>(
      callURL,
      data: body,
      options: dioPkg.Options(headers: headers, contentType: contentTypeHeader),
    );
    responseJson = _returnResponseDio(response);
    return jsonEncode(responseJson);
  }

  Future<dynamic> delete(String baseUrl, String url) async {
    var responseJson;
    log.info(baseUrl + url);
    var callURL = Uri.parse(baseUrl + url);
    final contentTypeHeader =
        _headers?[contentTypeKey] ?? dioPkg.Headers.jsonContentType;
    final response = await _dio.deleteUri<dynamic>(
      callURL,
      // data: body,
      options: dioPkg.Options(headers: headers, contentType: contentTypeHeader),
    );
    responseJson = _returnResponseDio(response);
    return jsonEncode(responseJson);
  }

  Future<dynamic> multiPart(http_client.MultipartRequest request) async {
    var responseJson;
    try {
      final response = await request.send();
      print('Headerssssssssss---------------------------------');
      log.info(request.headers);
      final res = await http_client.Response.fromStream(response)
          .timeout(Duration(seconds: connectTimeout), onTimeout: () {
        throw FetchDataException(
            {'statusCode': 3, 'message': 'Connexion timeout'.tr});
      });
      responseJson = _returnResponse(res);
      log.info(responseJson);
    } on SocketException {
      throw FetchDataException(
          {'statusCode': 1, 'message': 'Server not available'.tr});
    } on HttpException {
      throw FetchDataException(
          {'statusCode': 2, 'message': 'No internet error'.tr});
    }
    return responseJson;
  }
}

dynamic _returnResponseDio(dioPkg.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = response.data;
      return responseJson;
    case 201:
      var responseJson = response.data;
      return responseJson;
    case 302:
      var responseJson = response.data;
      return responseJson;
    case 400:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 401:
      var errorResponse = makeErrorResponse(response);
      throw UnauthorisedException(errorResponse);
    case 403:
      var errorResponse = makeErrorResponse(response);
      throw UnauthorisedException(errorResponse);
    case 404:
      var errorResponse = makeErrorResponse(response);
      throw NotFoundException(errorResponse);
    case 415:
      var errorResponse = makeErrorResponse(response);
      throw NotFoundException(errorResponse);
    case 417:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 422:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 500:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
    case 502:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
    default:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
  }
}

dynamic _returnResponse(http_client.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = response.body;
      return responseJson;
    case 201:
      var responseJson = response.body;
      return responseJson;
    case 302:
      var responseJson = response.body;
      return responseJson;
    case 400:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 401:
      var errorResponse = makeErrorResponse(response);
      throw UnauthorisedException(errorResponse);
    case 403:
      var errorResponse = makeErrorResponse(response);
      throw UnauthorisedException(errorResponse);
    case 404:
      var errorResponse = makeErrorResponse(response);
      throw NotFoundException(errorResponse);
    case 415:
      var errorResponse = makeErrorResponse(response);
      throw NotFoundException(errorResponse);
    case 417:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 422:
      var errorResponse = makeErrorResponse(response);
      throw BadRequestException(errorResponse);
    case 500:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
    case 502:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
    default:
      var errorResponse = makeErrorResponse(response);
      throw FetchDataException(errorResponse);
  }
}

dynamic makeErrorResponse(response) {
  String? errorMessage = '';
  String? errorCode = '';
  var errorResponseObject = {};

  // Error errorObj = errorFromJson(response.body);
  if (response.body != null && response.body != '') {
    var decodeRes = json.decode(response.body);
    debugPrint(decodeRes.toString());
    if (decodeRes['detail'] != null && decodeRes['detail'] != '') {
      errorMessage = decodeRes['detail'];
    } else if (decodeRes['error_description'] != null &&
        decodeRes['error_description'] != '') {
      errorMessage = decodeRes['error_description'];
    } else if (decodeRes['message'] != null && decodeRes['message'] != '') {
      errorMessage = decodeRes['message'];
    } else if (decodeRes['error'] != null && decodeRes['error'] != '') {
      errorMessage = decodeRes['error'];
    }
    if (decodeRes['errorCode'] != null && decodeRes['errorCode'] != '') {
      errorCode = decodeRes['errorCode'];
    }
  } else {
    errorMessage = 'unexpected response from server';
  }
  errorResponseObject = {
    'statusCode': response.statusCode,
    'errorCode': errorCode,
    'message': errorMessage,
  };
  return errorResponseObject;
}
