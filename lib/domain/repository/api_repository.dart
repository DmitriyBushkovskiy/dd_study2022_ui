import 'package:dd_study2022_ui/domain/models/token_response.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';

abstract class ApiRepository {
  Future<TokenResponse?> getToken(
      {required String login, required String password});

  Future<TokenResponse?> refreshToken(String refreshToken);

  Future<User?> getUser();

  Future<UserProfile?> getUserProfile();
}