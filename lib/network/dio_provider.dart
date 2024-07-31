import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import 'ExceptionInterceptor.dart';

class DioSingleton {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 70),
    ),
  );

  // Private constructor to prevent instantiation
  DioSingleton._internal() {
    // Add TalkerDioLoggerInterceptor
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
  }

  // Getter for the singleton Dio instance
  static Dio get dio => _dio;

  // Singleton instance
  static final DioSingleton _instance = DioSingleton._internal();

  // Factory method to get the singleton instance
  factory DioSingleton() {
    return _instance;
  }
}
