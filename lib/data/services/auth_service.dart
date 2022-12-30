import 'dart:io';

import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
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
          var user = await _api.getCurrentUser();
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
      var user = await _api.getCurrentUser();
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
    //TODO: save data to DB
    return await _api.getUserProfile();
  }

    Future<User?> getUser(String targetUserId) async {
    var targetUser =  await _api.getUser(targetUserId);
    SyncService().syncUser(targetUserId);
    return targetUser; // TODO: get user from backend 2 times: here an in sync service
  }

  // Future<UserProfile?> getChatsList() async {
  //   //TokenStorage.getAccessToken();
  //   return await _api.getUserProfile();
  // }

  Future<List<PostModel>> getPostFeed(String? lastPostDate) async {
    var postModels = await _api.getPostFeedByLastPostDate(lastPostDate);
    SyncService().syncPosts(postModels);
    return postModels;
  }

  Future<PostModel> getPost(String? postId) async {
    var postModel = await _api.getPost(postId);
    SyncService().syncPosts([postModel]);
    return postModel;
  }

  Future<LikeDataModel> likePost(String? postId) async {
    var result = await _api.likePost(postId);
    return result;
  }

  Future<LikeDataModel> likeComment(String? commentId) async {
    var result = await _api.likeComment(commentId);
    return result;
  }

  Future deleteComment(String? commentId) async {
    await _api.deleteComment(commentId);
  }

  Future<CommentModel> changeComment(ChangeCommentModel model) async {
    var result = await _api.changeComment(model);
    return result;
  }

  Future createComment(CreateCommentModel model) async {
    await _api.createComment(model);
  }

  Future<List<CommentModel>> getComments(String postId) async {
    var result = await _api.getComments(postId);
    return result;
  }

  Future changePostDescription(ChangePostDescriptionModel model) async {
    await _api.changePostDescription(model);
  }

  Future deletePost(String postId) async {
    await _api.deletePost(postId);
  }

  Future<LikeDataModel> likeContent(String contentId) async {
    var result = await _api.likeContent(contentId);
    return result;
  }

  Future deletePostContent(String contentId) async {
    await _api.deletePostContent(contentId);
  }

  Future<bool> changeAvatarColor() async {
    var result = await _api.changeAvatarColor();
    return result;
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
