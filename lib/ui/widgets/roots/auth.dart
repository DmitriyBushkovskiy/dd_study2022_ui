import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/registration/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;
  const _ViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
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

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
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

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                ),
                Image.asset("assets/images/sadgram-logo.gif"),
                Container(
                  height: 120,
                ),
                TextField(
                  controller: viewModel.loginTec,
                  decoration: const InputDecoration(
                    hintText: "Enter Login",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                TextField(
                  controller: viewModel.passwTec,
                  obscureText: viewModel.obscurePassword,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        viewModel.hidePassword();
                      },
                      icon: Icon(viewModel.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: viewModel.checkFields() ? viewModel.login : null,
                    child: const Text("Login")),
                Container(
                  height: 70,
                ),
                Text("Don't you have an account yet?"),
                ElevatedButton(
                    onPressed: () => viewModel.toRegisterUserPage(context),
                    child: const Text("Register now!")),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(context: context),
        child: const Auth(),
      );
}
