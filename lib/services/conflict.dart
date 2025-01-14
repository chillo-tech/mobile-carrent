import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../models/booking.dart';
import '../network/api_provider.dart';

class ConflictService {
  var log = Logger("PostManagementService");

  ApiProvider apiProvider = ApiProvider();

  Future<String> reportAConflict(
      {required BookingResponse booking, required String description}) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.put(
      Env.getUserManagementApiBaseUrl(),
      'reservation/litige/${booking.id}',
      {'description': description},
    );
    print(response);
    return json.decode(response);
  }

  // Future<String> reportAConflict(dynamic authObject) async {
  //   log.info('HEADERS ${authObject.headers}');
  //   log.info('URL ${authObject.url}');
  //   log.info('FIELDS ${authObject.fields}');

  //   final response = await apiProvider.multiPart(
  //     authObject,
  //   );
  //   print(response);
  //   log.info('RESPONSE $response');
  //   return response;
  // }
}
