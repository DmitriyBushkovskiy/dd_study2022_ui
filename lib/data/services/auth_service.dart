import 'dart:io';

import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/domain/repository/api_repository.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiRepository _api = RepositoryModule.apiRepository();
  final DataService _dataService = DataService();

  Future auth(String? login, String? password) async {
    if (login != null && password != null) {
      try {
        var token = await _api.getToken(login: login, password: password);
        if (token != null) {
          await TokenStorage.setStoredToken(token);
          var user = await _api.getUser();
          if (user != null) {
            SharedPrefs.setStoredUser(user);
          }
        }
      } on DioError catch (e) {
        if (e.error is SocketException) {
          throw NoNetworkException();
        } else if (<int>[401].contains(e.response?.statusCode)) {
          throw UnautorizedException(e.response!.data);
        } else if (<int>[404].contains(e.response?.statusCode)) {
          throw NotFoundException(e.response!.data);
        } else if (<int>[500].contains(e.response?.statusCode)) {
          throw ServerException();
        }
      }
    }
  }

  Future<bool> checkAuth() async {
    var res = false;

    if (await TokenStorage.getAccessToken() != null) {
      var user = await _api.getUser();
      if (user != null) {
        await SharedPrefs.setStoredUser(user);
        await _dataService.cuUser(user);
      }
      res = true;
    }
    return res;
  }

  Future logout() async {
    await TokenStorage.setStoredToken(null);
  }

  //TODO: перенести в другой сервис?
  Future<UserProfile?> getUserProfile() async {
    //TokenStorage.getAccessToken();
    return await _api.getUserProfile();
  }

  Future<UserProfile?> getChatsList() async {
    //TokenStorage.getAccessToken();
    return await _api.getUserProfile();
  }

  Future<List<PostModel>> getPostFeed(String? lastPostDate) async {
    var postModels = await _api.getPostFeedByLastPostDate(lastPostDate);
    SyncService().syncPosts(postModels);
    return postModels;
  }
}

class NoNetworkException implements Exception {}

class ServerException implements Exception {}

class UnautorizedException implements Exception {
  final String errorMessage;
  UnautorizedException(this.errorMessage);
}

class NotFoundException implements Exception {
  final String errorMessage;
  NotFoundException(this.errorMessage);
}
