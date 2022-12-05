import 'package:dd_study2022_ui/data/clients/api_client.dart';
import 'package:dd_study2022_ui/data/clients/auth_client.dart';
import 'package:dd_study2022_ui/domain/models/refresh_token_request.dart';
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
  Future<User?> getUser() => _api.getUser();

  @override
  Future<UserProfile?> getUserProfile() => _api.getUserProfile();
}