import 'dart:io';

import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
import 'package:dd_study2022_ui/domain/models/token_response.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});

  Future<TokenResponse?> refreshToken(String refreshToken);

  Future registerUser(RegisterUserRequest body);

  Future<User?> getCurrentUser();

  Future<User?> getUser(String targetUserId);

  Future<UserProfile?> getUserProfile();

  Future<List<PostModel>> getPostFeed(int skip, int take);

  Future<List<PostModel>> getPostFeedByLastPostDate(String? lastPostDate);

  Future<PostModel> getPost(String? postId);

  Future<LikeDataModel> likePost(String? postId);

  Future<LikeDataModel> likeComment(String? commentId);

  Future<CommentModel> changeComment(ChangeCommentModel model);

  Future deleteComment(String? commentId);

  Future createComment(CreateCommentModel model);

  Future<List<AttachMeta>> uploadTemp({required List<File> files});

  Future addAvatarToUser(AttachMeta model);

  Future createPost(CreatePostModel model);

  Future changePostDescription(ChangePostDescriptionModel model);

  Future<List<CommentModel>> getComments(String postId);

  Future deletePost(String postId);

  Future<LikeDataModel> likeContent(String contentId);

  Future deletePostContent(String contentId);

  Future<bool> changeAvatarColor();
}
