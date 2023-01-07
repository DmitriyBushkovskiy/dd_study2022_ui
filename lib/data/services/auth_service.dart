import 'dart:io';

import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/enums/relation_state.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/data_by_userid_request.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/push_token.dart';
import 'package:dd_study2022_ui/domain/models/relation_state_model.dart';
import 'package:dd_study2022_ui/domain/models/search_users_request.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/domain/repository/api_repository.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/internal/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
        var token = await FirebaseMessaging.instance.getToken();
        if (token != null) await _api.subscribe(PushToken(token: token));
        await SharedPrefs.setStoredUser(user);
        await _dataService.cuUser(user);
      }
      res = true;
    }
    return res;
  }

  Future cleanToken() async {
    await TokenStorage.setStoredToken(null);
  }

  Future logout() async {
    try {
      await _api.unsubscribe();
    } on Exception catch (e, _) {
      e.toString().console();
    }
    await cleanToken();
  }

//Post
  Future<PostModel> getPost(String? postId) async {
    var postModel = await _api.getPost(postId);
    SyncService().syncPosts([postModel]);
    return postModel;
  }

  Future<List<PostModel>> getPostFeed(String? lastPostDate) async {
    var postModels = await _api.getPostFeedByLastPostDate(lastPostDate);
    SyncService().syncPosts(postModels);
    return postModels;
  }

  Future<List<PostModel>> getPosts(GetPostsRequestModel model) async {
    var postModels = await _api.getPostsByLastPostDate(model);
    SyncService().syncPosts(postModels);
    return postModels;
  }

  Future<List<PostModel>> getFavoritePosts(GetPostsRequestModel model) async {
    var postModels = await _api.getFavoritePosts(model);
    SyncService().syncPosts(postModels);
    return postModels;
  }

  Future changePostDescription(ChangePostDescriptionModel model) async {
    await _api.changePostDescription(model);
  }

  Future<LikeDataModel> likePost(String? postId) async {
    var result = await _api.likePost(postId);
    return result;
  }

  Future deletePost(String postId) async {
    await _api.deletePost(postId);
  }

  Future createComment(CreateCommentModel model) async {
    await _api.createComment(model);
  }

  Future<List<CommentModel>> getComments(String postId) async {
    var result = await _api.getComments(postId);
    return result;
  }

  Future<CommentModel> changeComment(ChangeCommentModel model) async {
    var result = await _api.changeComment(model);
    return result;
  }

  Future<LikeDataModel> likeComment(String? commentId) async {
    var result = await _api.likeComment(commentId);
    return result;
  }

  Future deleteComment(String? commentId) async {
    await _api.deleteComment(commentId);
  }

  Future<LikeDataModel> likeContent(String contentId) async {
    var result = await _api.likeContent(contentId);
    return result;
  }

  Future deletePostContent(String contentId) async {
    await _api.deletePostContent(contentId);
  }

//Relation

  Future<RelationStateModel> getRelations(String targetUserId) async {
    var result = await _api.getRelations(targetUserId);
    return result;
  }

  Future<RelationStateEnum> follow(String targetUserId) async {
    return await _api.follow(targetUserId).then((value) =>
        RelationStateEnum.values.firstWhere(
            (e) => e.toString() == 'RelationStateEnum.${value.toLowerCase()}'));
  }

  Future<RelationStateEnum> ban(String targetUserId) async {
    return await _api.ban(targetUserId).then((value) => RelationStateEnum.values
        .firstWhere(
            (e) => e.toString() == 'RelationStateEnum.${value.toLowerCase()}'));
  }

  Future<RelationStateEnum> unban(String targetUserId) async {
    return await _api.unban(targetUserId).then((value) =>
        RelationStateEnum.values.firstWhere(
            (e) => e.toString() == 'RelationStateEnum.${value.toLowerCase()}'));
  }

  Future<List<User>> searchUsers(SearchUserRequest model) async {
    var result = _api.searchUsers(model);
    return result;
  }

  Future<RelationStateEnum> acceptRequest(String targetUserId) async {
    return await _api.acceptRequest(targetUserId).then((value) =>
        RelationStateEnum.values.firstWhere(
            (e) => e.toString() == 'RelationStateEnum.${value.toLowerCase()}'));
  }

  Future<List<User>> getFollowers(DataByUserIdRequest model) async {
    var result = _api.getFollowers(model);
    return result;
  }

  Future<List<User>> getBanned(DataByUserIdRequest model) async {
    var result = _api.getBanned(model);
    return result;
  }

  Future<List<User>> getFollowed(DataByUserIdRequest model) async {
    var result = _api.getFollowed(model);
    return result;
  }

  Future<List<User>> getFollowersRequests(DataByUserIdRequest model) async {
    var result = _api.getFollowersRequests(model);
    return result;
  }

  //User

  Future<bool> changeAvatarColor() async {
    var result = await _api.changeAvatarColor();
    return result;
  }

  Future<User?> getUser(String targetUserId) async {
    var targetUser = await _api.getUser(targetUserId);
    SyncService().syncUser(targetUserId);
    return targetUser;
  }

  Future<UserProfile?> getUserProfile() async {
    //TODO: save data to DB
    return await _api.getUserProfile();
  }

  //Push

  //   @override
  // Future subscribe(PushToken model);

  // @override
  // Future unsubscribe();
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
