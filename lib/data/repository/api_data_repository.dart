import 'dart:io';

import 'package:dd_study2022_ui/data/clients/api_client.dart';
import 'package:dd_study2022_ui/data/clients/auth_client.dart';
import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/refresh_token_request.dart';
import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
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
  Future registerUser(RegisterUserRequest body) async => await _auth.registerUser(body);

  @override
  Future<User?> getUser() => _api.getUser();

  @override
  Future<UserProfile?> getUserProfile() => _api.getUserProfile();

  @override
  Future<List<PostModel>> getPostFeed(int skip, int take) =>
      _api.getPostFeed(skip, take);

  @override
  Future<List<PostModel>> getPostFeedByLastPostDate(String? lastPostDate) =>
      _api.getPostFeedByLastPostDate(lastPostDate);

  @override
  Future<List<AttachMeta>> uploadTemp({required List<File> files}) =>
      _api.uploadTemp(files: files);

  @override
  Future addAvatarToUser(AttachMeta model) => _api.addAvatarToUser(model);

  @override
  Future createPost(CreatePostModel model) => _api.createPost(model);
}
