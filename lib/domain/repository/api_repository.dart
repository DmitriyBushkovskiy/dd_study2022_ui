import 'dart:io';

import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
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

  Future<User?> getUser();

  Future<UserProfile?> getUserProfile();

  Future<List<PostModel>> getPostFeed(int skip, int take);

  Future<List<PostModel>> getPostFeedByLastPostDate(String? lastPostDate);

  Future<List<AttachMeta>> uploadTemp({required List<File> files});
  
  Future addAvatarToUser(AttachMeta model);

  Future createPost(CreatePostModel model);
}