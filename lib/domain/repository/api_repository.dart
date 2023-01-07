import 'dart:io';

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
import 'package:dd_study2022_ui/domain/models/push_token.dart';
import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
import 'package:dd_study2022_ui/domain/models/relation_state_model.dart';
import 'package:dd_study2022_ui/domain/models/search_users_request.dart';
import 'package:dd_study2022_ui/domain/models/token_response.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});

  Future<TokenResponse?> refreshToken(String refreshToken);

  //Attach

  Future<List<AttachMeta>> uploadTemp({required List<File> files});

//Chat

//Post

  Future createPost(CreatePostModel model);

  Future<PostModel> getPost(String? postId);

  Future<List<PostModel>> getPostFeedByLastPostDate(String? lastPostDate);

  Future<List<PostModel>> getPostsByLastPostDate(GetPostsRequestModel model);

  Future<List<PostModel>> getFavoritePosts(GetPostsRequestModel model);

  Future registerUser(RegisterUserRequest body);

  Future changePostDescription(ChangePostDescriptionModel model);

  Future<LikeDataModel> likePost(String? postId);

  Future deletePost(String postId);

  Future createComment(CreateCommentModel model);

  Future<List<CommentModel>> getComments(String postId);

  Future<CommentModel> changeComment(ChangeCommentModel model);

  Future<LikeDataModel> likeComment(String? commentId);

  Future deleteComment(String? commentId);

  Future<LikeDataModel> likeContent(String contentId);

  Future deletePostContent(String contentId);

//Relation

  Future<RelationStateModel> getRelations(String targetUserId);

  Future<String> follow(String targetUserId);

  Future<String> ban(String targetUserId);

  Future<String> unban(String targetUserId);

  Future<List<User>> searchUsers(SearchUserRequest model);

  Future<String> acceptRequest(String targetUserId);

  Future<List<User>> getFollowers(DataByUserIdRequest model);

  Future<List<User>> getBanned(DataByUserIdRequest model);

  Future<List<User>> getFollowed(DataByUserIdRequest model);

  Future<List<User>> getFollowersRequests(DataByUserIdRequest model);

  //User

  Future addAvatarToUser(AttachMeta model);

  Future<bool> changeAvatarColor();

  Future<User?> getUser(String targetUserId);

  Future<User?> getCurrentUser();

  Future<UserProfile?> getUserProfile();

  // Push
  @override
  Future subscribe(PushToken model);

  @override
  Future unsubscribe();
}
