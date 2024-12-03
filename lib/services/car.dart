import 'dart:convert';

import '../models/car_response.dart';

import '../models/post_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../network/api_provider.dart';

class CarService {
  var log = Logger("PostManagementService");

  ApiProvider apiProvider = ApiProvider();

  final langCode = GetStorage().read(StorageConstants.langCode) ?? 'en';

  Future<List<CarResponse>> getCars() async {
    log.info('HEADERS ${apiProvider.headers}');

    // String token = await GetStorage().read(StorageConstants.refreshToken);
    // apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.get(
      Env.getUserManagementApiBaseUrl(),
      'cars',
    );
    print(response);
    return carResponsefromJsonList(json.decode(response));
  }
}
