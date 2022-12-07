import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/app_navigator.dart';
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

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();
  bool obscureText = true;

  BuildContext context;
  _ViewModel({required this.context}) {
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

  void hidePassword(val) {
    obscureText = val;
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
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 80,),
                Image.asset("assets/images/sadgram-logo.gif"),
                Container(height: 170,),
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
                  obscureText: viewModel.obscureText,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        viewModel.hidePassword(!viewModel.obscureText);
                      },
                      icon: Icon(viewModel.obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: viewModel.checkFields() ? viewModel.login : null,
                    child: const Text("Login")),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!)
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Auth(),
      );
}
