import 'dart:io';

import 'package:dd_study2022_ui/data/clients/api_client.dart';
import 'package:dd_study2022_ui/data/clients/auth_client.dart';
import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/data_by_userid_request.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/refresh_token_request.dart';
import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
import 'package:dd_study2022_ui/domain/models/relation_state_model.dart';
import 'package:dd_study2022_ui/domain/models/search_users_request.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/domain/repository/api_repository.dart';
import 'package:dd_study2022_ui/domain/models/token_request.dart';
import 'package:dd_study2022_ui/domain/models/token_response.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _auth;
  final ApiClient _api;
  ApiDataRepository(this._auth, this._api);

  @override
  Future<TokenResponse?> getToken({
    required String login,
    required String password,
  }) async {
    return await _auth.getToken(TokenRequest(
      login: login,
      pass: password,
    ));
  }

  @override
  Future<TokenResponse?> refreshToken(String refreshToken) async =>
      await _auth.refreshToken(RefreshTokenRequest(
        refreshToken: refreshToken,
      ));

  @override
  Future registerUser(RegisterUserRequest body) async =>
      await _auth.registerUser(body);

//Attach

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

//Chat

//Post

  @override
  Future createPost(CreatePostModel model) => _api.createPost(model);

  @override
  Future<PostModel> getPost(String? postId) => _api.getPost(postId);

  @override
  Future<List<PostModel>> getPostFeedByLastPostDate(String? lastPostDate) =>
      _api.getPostFeedByLastPostDate(lastPostDate);

  @override
  Future<List<PostModel>> getPostsByLastPostDate(GetPostsRequestModel model) =>
      _api.getPostsByLastPostDate(model);

  @override
  Future<List<PostModel>> getFavoritePosts(GetPostsRequestModel model) =>
      _api.getFavoritePosts(model);

  @override
  Future changePostDescription(ChangePostDescriptionModel model) =>
      _api.changePostDescription(model);

  @override
  Future<LikeDataModel> likePost(String? postId) => _api.likePost(postId);

  @override
  Future deletePost(String postId) => _api.deletePost(postId);

  @override
  Future createComment(CreateCommentModel model) => _api.createComment(model);

  @override
  Future<List<CommentModel>> getComments(String postId) =>
      _api.getComments(postId);

  @override
  Future<CommentModel> changeComment(ChangeCommentModel model) =>
      _api.changeComment(model);

  @override
  Future<LikeDataModel> likeComment(String? commentId) =>
      _api.likeComment(commentId);

  @override
  Future deleteComment(String? commentId) => _api.deleteComment(commentId);

  @override
  Future<LikeDataModel> likeContent(String contentId) =>
      _api.likeContent(contentId);

  @override
  Future deletePostContent(String contentId) =>
      _api.deletePostContent(contentId);

//Relation

  @override
  Future<RelationStateModel> getRelations(String targetUserId) =>
      _api.getRelations(targetUserId);

  @override
  Future<String> follow(String targetUserId) => _api.follow(targetUserId);

  @override
  Future<String> ban(String targetUserId) => _api.ban(targetUserId);

  @override
  Future<String> unban(String targetUserId) => _api.unban(targetUserId);

  @override
  Future<List<User>> searchUsers(SearchUserRequest model) =>
      _api.searchUsers(model);

  @override
  Future<String> acceptRequest(String targetUserId) =>
      _api.acceptRequest(targetUserId);

  @override
  Future<List<User>> getFollowers(DataByUserIdRequest model) =>
      _api.getFollowers(model);

  @override
  Future<List<User>> getBanned(DataByUserIdRequest model) =>
      _api.getBanned(model);

  @override
  Future<List<User>> getFollowed(DataByUserIdRequest model) =>
      _api.getFollowed(model);

  @override
  Future<List<User>> getFollowersRequests(DataByUserIdRequest model) =>
      _api.getFollowersRequests(model);

//User

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  @override
  Future<bool> changeAvatarColor() => _api.changeAvatarColor();

  @override
  Future<User?> getUser(String targetUserId) => _api.getUser(targetUserId);

  @override
  Future<User?> getCurrentUser() => _api.getCurrentUser();

  @override
  Future<UserProfile?> getUserProfile() => _api.getUserProfile();
}
