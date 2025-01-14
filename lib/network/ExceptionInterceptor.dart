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
    // Si la réponse est réussie, la retourner
    if (response.statusCode == 200) {
      var log = Logger("ApiProvider");
      log.info('RÉPONSE $response');
      return handler.next(response);
    }

    // Gérer les codes d'état spécifiques et lancer FetchDataException en conséquence
    if (response.statusCode == 408) {
      throw FetchDataException({
        'statusCode': 3,
        'message': 'erreur_connexion_timeout'.tr,
      });
    } else if (response.statusCode == 404) {
      throw FetchDataException({
        'statusCode': 2,
        'message': 'erreur_pas_internet'.tr,
      });
    } else {
      // Vous pouvez gérer d'autres codes d'état si nécessaire
      return handler.next(response);
    }
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
<<<<<<< Updated upstream
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
        'message': 'server_not_available_error',
      });
    } else if (err.error is HttpException) {
      throw FetchDataException({
        'statusCode': 2,
        'message': 'no_internet_error'.tr,
      });
    } else {
      // You can handle other Dio errors as needed
=======
    try {
      // Gérer les erreurs non autorisées ou interdites
      if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
        print("Non autorisé ou Interdit: ${err.response?.statusCode}");
        return handler.next(err);
      }

      // Gérer les erreurs liées au réseau
      // if (err.error is SocketException) {
      //   throw FetchDataException({
      //     'statusCode': 1,
      //     'message': 'Serveur non disponible',
      //   });
      // } else if (err.error is HttpException) {
      //   throw FetchDataException({
      //     'statusCode': 2,
      //     'message': 'Pas de connexion internet',
      //   });
      // } else if (err.type == DioExceptionType.connectionTimeout) {
      //   throw FetchDataException({
      //     'statusCode': 3,
      //     'message': 'Délai de connexion dépassé',
      //   });
      // } else if (err.type == DioExceptionType.receiveTimeout) {
      //   throw FetchDataException({
      //     'statusCode': 4,
      //     'message': 'Délai de réception dépassé',
      //   });
      // }

      // Gérer toutes les autres erreurs Dio
      print("Erreur Dio non gérée: ${err.message}");
>>>>>>> Stashed changes
      return handler.next(err);
    } catch (e) {
      print("Erreur lors de la gestion de l'exception: $e");
      rethrow; // Relancer l'erreur après la gestion
    }
  }
}
