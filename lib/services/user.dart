import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../models/user_response.dart';
import '../network/api_provider.dart';
import 'package:http/http.dart' as http;

class UserService {
  var log = Logger("AuthService");

  ApiProvider apiProvider = new ApiProvider();

  Future<UserResponse> updateUserprofile(http.MultipartRequest  request) async {
    log.info('HEADERS ${request.headers}');
    log.info('URL ${request.url}');
    log.info('FIELDS ${request.fields}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');

    final response = await apiProvider.multiPart(request);
    // return response;
    return userResponseFromJson(response);
  }
}
