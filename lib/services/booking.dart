import 'dart:convert';

import '../models/booking.dart';

import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../env.dart';
import '../network/api_provider.dart';

class BookingService {
  var log = Logger("PostManagementService");

  ApiProvider apiProvider = ApiProvider();

  final langCode = GetStorage().read(StorageConstants.langCode) ?? 'en';

  Future<List<BookingResponse>> getBookings({required String userid}) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.get(
      Env.getUserManagementApiBaseUrl(),
      'reservation/$userid',
    );
    print(response);
    return bookingResponsefromJsonList(json.decode(response));
  }

  Future<Map<String, dynamic>> bookACar(dynamic bookingObject) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'reservation/initreservation/link',
      body: bookingObject,
    );
    print(response);
    return json.decode(response);
  }

  Future<String> cancelBooking({required BookingResponse booking}) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); //$token');
    final response = await apiProvider.get(
      Env.getUserManagementApiBaseUrl(),
      'reservation/cancelreservation/${booking.sessionId}?idReservation=${booking.id}',
    );
    print(response);
    return json.decode(response);
  }

  Future<Map<String, dynamic>> withdrawBooking(dynamic authObject) async {
    log.info('HEADERS ${authObject.headers}');
    log.info('URL ${authObject.url}');
    log.info('FIELDS ${authObject.fields}');

    final response = await apiProvider.multiPart(
      authObject,
    );
    print(response);
    print(response.runtimeType);
    log.info('RESPONSE ${response}');
    return json.decode(response);
  }
}