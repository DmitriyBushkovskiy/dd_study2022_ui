import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/registration/registration_widget.dart';
import 'package:flutter/material.dart';

class AuthViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;
  const AuthViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
    this.errorText,
  });

  AuthViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return AuthViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class AuthViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();
  bool obscurePassword = true;

  BuildContext context;
  AuthViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  var _state = const AuthViewModelState();
  AuthViewModelState get state => _state;
  set state(AuthViewModelState val) {
    _state = val;
    notifyListeners();
  }

    void toRegisterUserPage(BuildContext bc) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => RegistrationWidget.create(bc)));
  }

  void hidePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false);
  }

  void login() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.auth(state.login, state.password).then((value) {
        AppNavigator.toLoader()
            .then((value) => {state = state.copyWith(isLoading: false)});
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on UnautorizedException catch (e) {
      state = state.copyWith(errorText: e.errorMessage);
    } on NotFoundException catch (e) {
      state = state.copyWith(errorText: e.errorMessage);
    } on ServerException {
      state = state.copyWith(errorText: "ошибка на сервере");
    }
  }
}