import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../common/storage_constants.dart';
import '../models/login_response.dart';
import '../models/user_response.dart';

class UserController extends GetxController {
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  UserResponse? currentuser;

  @override
  onInit() {
    super.onInit();
    retreiveUserData();
  }

  Future<void> saveUserData(LoginResponse response) async {
    await flutterSecureStorage.write(
        key: StorageConstants.id, value: response.user.id);
    await flutterSecureStorage.write(
        key: StorageConstants.firstName, value: response.user.firstName);
    await flutterSecureStorage.write(
        key: StorageConstants.lastName, value: response.user.lastName);
    await flutterSecureStorage.write(
        key: StorageConstants.email, value: response.user.email);
    await flutterSecureStorage.write(
        key: StorageConstants.phone, value: response.user.phoneNumber);
  }

  Future<void> retreiveUserData() async {
    String id = await flutterSecureStorage.read(key: StorageConstants.id) ?? '';
    String firstName =
        await flutterSecureStorage.read(key: StorageConstants.firstName) ?? '';
    String lastName =
        await flutterSecureStorage.read(key: StorageConstants.lastName) ?? '';
    String email =
        await flutterSecureStorage.read(key: StorageConstants.email) ?? '';
    String phone =
        await flutterSecureStorage.read(key: StorageConstants.phone) ?? '';

    currentuser = UserResponse(
        id: id,
        firstName: firstName,
        email: email,
        lastName: lastName,
        phoneNumber: phone);
  }

  Future<void> clearUserData() async {
    await flutterSecureStorage.delete(key: StorageConstants.id);
    await flutterSecureStorage.delete(key: StorageConstants.firstName);
    await flutterSecureStorage.delete(key: StorageConstants.lastName);
    await flutterSecureStorage.delete(key: StorageConstants.email);
    await flutterSecureStorage.delete(key: StorageConstants.phone);
  }
}
