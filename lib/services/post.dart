import 'dart:convert';

import '../models/car_response.dart';

import '../models/post_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../src/features/auth/login/login_response.dart';
import '../network/api_provider.dart';
import '../network/auth_headers.dart';

class PostService {
  var log = Logger("PostManagementService");

  ApiProvider apiProvider = new ApiProvider();

  final langCode = GetStorage().read(StorageConstants.langCode) ?? 'en';

  Future<CarResponse> createOrEditPost(dynamic authObject) async {
    log.info('HEADERS ${authObject.headers}');
    log.info('URL ${authObject.url}');
    log.info('FIELDS ${authObject.fields}');

    final response = await apiProvider.multiPart(
      authObject,
    );
    print(response);
    return carResponseFromJson(response);
  }

  Future<List<CarResponse>> getMyPosts() async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.get(
      Env.getUserManagementApiBaseUrl(),
      'cars/user',
    );
    print(response);
    return carResponsefromJsonList(json.decode(response));
  }

  Future<String> deleteMyPost(String postId) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.delete(
      Env.getUserManagementApiBaseUrl(),
      'cars/$postId',
    );
    print(response);
    return response;
  }
}
