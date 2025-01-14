import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../models/login_response.dart';
import '../network/api_provider.dart';

class AuthService {
  var log = Logger("AuthService");

  ApiProvider apiProvider = new ApiProvider();

  final langCode = GetStorage().read(StorageConstants.langCode) ?? 'en';

  Future<LoginResponse> login(dynamic authObject) async {
    apiProvider.headers!.remove("Authorization");
    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'login',
      body: authObject,
    );

    return loginResponseFromJson(response);
  }

  Future<String> register(dynamic authObject) async {
    // Map<String, String> correlationMap =
    //     await AuthHeaders().getCorrelationMap();

    // apiProvider.headers = correlationMap;
    // apiProvider.headers!.putIfAbsent("Accept-Language", () => langCode);
    // apiProvider.headers!
    //     .putIfAbsent(Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);

    apiProvider.headers!.remove("Authorization");
    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'register',
      body: authObject,
    );
    return response;
    // return loginResponseFromJson(response);
  }

  Future<String> activate(dynamic authObject) async {
    // Map<String, String> correlationMap =
    //     await AuthHeaders().getCorrelationMap();

    // apiProvider.headers = correlationMap;
    // apiProvider.headers!.putIfAbsent("Accept-Language", () => langCode);
    // apiProvider.headers!
    //     .putIfAbsent(Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);

    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'active?otp=${authObject['otp']}',
      body: authObject,
    );

    return response;
  }

  Future<String> sendResetPasswordEmailOrSms(String recipientChannel) async {
    // Map<String, String> correlationMap =
    //     await AuthHeaders().getCorrelationMap();

    // apiProvider.headers = correlationMap;
    // apiProvider.headers!.putIfAbsent("Accept-Language", () => langCode);
    // apiProvider.headers!
    //     .putIfAbsent(Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);

    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(Env.getUserManagementApiBaseUrl(),
        'renew-password-initialize?email=$recipientChannel');

    return response;
  }

  Future<String> validateResetPasswordCode(
      {required String otp, required String recipientChannel}) async {
    // Map<String, String> correlationMap =
    //     await AuthHeaders().getCorrelationMap();

    // apiProvider.headers = correlationMap;
    // apiProvider.headers!.putIfAbsent("Accept-Language", () => langCode);
    // apiProvider.headers!
    //     .putIfAbsent(Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);

    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'renew-password-verify?email=$recipientChannel&otp=$otp',
      // body: authObject,
    );

    return response;
  }

  Future<String> setUpNewPassword(dynamic payload) async {
    // Map<String, String> correlationMap =
    //     await AuthHeaders().getCorrelationMap();

    // apiProvider.headers = correlationMap;
    // apiProvider.headers!.putIfAbsent("Accept-Language", () => langCode);
    // apiProvider.headers!
    //     .putIfAbsent(Constants.API_GATEWAY_KEY, () => ApiKey.apiGatewayKey);

    log.info('HEADERS ${apiProvider.headers}');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'renew-password',
      body: payload,
    );

    return response;
  }
}
