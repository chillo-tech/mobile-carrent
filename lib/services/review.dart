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

class ReviewService {
  var log = Logger("ReviewService");

  ApiProvider apiProvider = new ApiProvider();

  final langCode = GetStorage().read(StorageConstants.langCode) ?? 'en';

  Future<List<Review>> getPostReviews(String carId) async {
    log.info('HEADERS ${apiProvider.headers}');

    // String token = await GetStorage().read(StorageConstants.refreshToken);
    // apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); // $token');
    final response = await apiProvider.get(
      Env.getUserManagementApiBaseUrl(),
      'reviews/vehicles/$carId',
    );
    print(response);
    return reviewResponsefromJsonList(json.decode(response));
  }

  Future<Review> reviewPost(Review review, String carId) async {
    log.info('HEADERS ${apiProvider.headers}');

    String token = await GetStorage().read(StorageConstants.refreshToken);
    apiProvider.headers!.putIfAbsent("Authorization", () => 'Bearer $token');
    // 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnYWVsQGVtYWlsMnRlc3QuY29tIiwiZXhwIjoxNzU2MTk1MzU4LCJlbWFpbCI6ImdhZWxAZW1haWwydGVzdC5jb20ifQ.mE5mvtMCbwdciKbQ2QiXyadfofjcsnBUdodLpz4SDfzzUncUlY5BP27cQZMrSdtST1ekVg4O7xQ-QmeiJGaG6g'); // $token');
    final response = await apiProvider.post(
      Env.getUserManagementApiBaseUrl(),
      'reviews/vehicles/$carId',
      body: review.toJson(),
    );
    print(response);
    return reviewResponseFromJson(response);
  }
}
