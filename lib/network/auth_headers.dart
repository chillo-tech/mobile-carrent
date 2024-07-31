import 'dart:math';

//import 'package:dart_ipify/dart_ipify.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../common/storage_constants.dart';
import '../models/login_response.dart';

class AuthHeaders {
  var log = Logger("AuthHeaders");
  String get tokenType {
    return GetStorage().read('tokenType');
  }

  Future<String> get accessToken async {
    // var tokenExpiry = GetStorage().read('tokenExpiry');
    DateTime tokenExpiryDate;
    DateFormat dateFormat;
    dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    tokenExpiryDate = dateFormat.parse(GetStorage().read('tokenExpiryTime'));
    log.info(dateFormat.format(tokenExpiryDate));
    var token = GetStorage().read('accessToken');
    if (dateFormat
            .parse(dateFormat.format(DateTime.now()))
            .isBefore(tokenExpiryDate) &&
        token != null) {
      log.info("not required to update token");
      return token;
    } else {
      log.info("Calling Refresh Token Api");
      try {
        LoginResponse loginResponse = await refreshSession();
        await GetStorage().write('tokenType', loginResponse.tokenType);
        await GetStorage().write('accessToken', loginResponse.accessToken);
        await GetStorage().write('refreshToken', loginResponse.refreshToken);
        await GetStorage().write('tokenExpiry', loginResponse.expiresIn);
        await GetStorage().write(
          'tokenExpiryTime',
          dateFormat.format(
            DateTime.now().add(
              Duration(seconds: loginResponse.expiresIn ?? 0),
            ),
          ),
        );
        await GetStorage()
            .write('refreshTokenExpiry', loginResponse.refreshExpiresIn);
      } catch (e) {
        //Logout User
        var isLoggedIn = GetStorage().read(StorageConstants.loggedIn);
        isLoggedIn = isLoggedIn != null ? isLoggedIn : false;
        if (isLoggedIn) {
          // HomeController homeController = Get.find();
          // homeController.logoutUser('logout_session_expired'.tr);
        }
      }
    }
    return GetStorage().read('accessToken');
  }

  Future<dynamic> refreshSession() async {
    // AuthService authService = new AuthService();
    // try {
    //   var requestObject = {
    //     'client_id': 'PUBLIC_CLIENT',
    //     'grant_type': 'refresh_token',
    //     'refresh_token': GetStorage().read('refreshToken'),
    //   };
    //   return await authService.refreshToken(requestObject);
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<Map<String, String>> setAuthHeaders() async {
    Map<String, String> correlationMap = {};
    String token = tokenType + ' ' + await accessToken;
    correlationMap.putIfAbsent('Authorization', () => token);
    return correlationMap;
  }

  static const _chars = 'abcdef1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
