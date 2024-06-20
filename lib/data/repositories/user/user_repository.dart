import 'dart:convert';
import 'dart:io';

import 'package:effort/features/authentication/models/user_model.dart';
import 'package:effort/utils/exceptions/http_exception.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/http/http_client.dart';

class UserRepository extends GetxController {

  static UserRepository get instance => Get.find();

  // Fetch User Details
  Future<UserModel> fetchUserDetails(String username, String? jwt) async {
    try {
      var endpoint = 'api/users/$username';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      return UserModel.fromJson(response);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Get Users by Search Word
  Future<List<UserModel>> getUsersBySearchWord(String searchWord, String? jwt) async {
    try {
      var endpoint = 'api/users?s=$searchWord';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      List<UserModel> users = <UserModel>[];
      for (var user in response['users']) {
        users.add(UserModel.fromJson(user));
      }

      return users;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateUser(UserModel userToUpdate, String jwt) async {
    try {
      var endpoint = 'api/users/${userToUpdate.username}';
      await EffortHttpHelper.put(endpoint, userToUpdate.toJson(), jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateUserUsername(UserModel userToUpdate, String currentUsername, String jwt) async {
    try {
      var endpoint = 'api/users/$currentUsername';
      await EffortHttpHelper.put(endpoint, userToUpdate.toJson(), jwt);
    } catch (e) {
      if (e is EffortHttpException) {
        throw json.decode(e.responseBody)['message'];
      } else {
        throw 'Something went wrong. Please try again.';
      }
    }
  }

  Future<Map<String, dynamic>> uploadImage(XFile file, String fileName, String jwt) async {
    try {
      var endpoint = 'api/files';
      File fileToSend = File(file.path);
      return await EffortHttpHelper.postFile(endpoint, fileName, fileToSend, jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<Map<String, dynamic>> updateImage(int fileId, XFile file, String fileName, String jwt) async {
    try {
      var endpoint = 'api/files/$fileId';
      File fileToSend = File(file.path);
      return await EffortHttpHelper.putFile(endpoint, fileName, fileToSend, jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> addImageToUser(String username, int fileId, String jwt) async {
    try {
      var endpoint = 'api/users/$username/files/$fileId';
      await EffortHttpHelper.post(endpoint, null, jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<File> getImage(int fileId, String jwt) async {
    try {
      var endpoint = 'api/files/$fileId';
      return EffortHttpHelper.getFile(endpoint, fileId, jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

}