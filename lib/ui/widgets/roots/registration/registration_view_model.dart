import 'package:dd_study2022_ui/domain/models/register_user_request.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _RegistrationViewModelState {
  final String? username;
  final String? email;
  final String? password;
  final String? repeatPassword;
  final bool obscurePassword;
  final DateTime? pickedDate;
  final String? errorText;
  final bool registrationInProcess;

  const _RegistrationViewModelState({
    this.username,
    this.email,
    this.password,
    this.repeatPassword,
    this.obscurePassword = true,
    this.pickedDate,
    this.errorText,
    this.registrationInProcess = false,
  });

  _RegistrationViewModelState copyWith({
    String? username,
    String? email,
    String? password,
    String? repeatPassword,
    bool? obscurePassword,
    DateTime? pickedDate,
    String? errorText,
    bool? registrationInProcess,
  }) {
    return _RegistrationViewModelState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      pickedDate: pickedDate ?? this.pickedDate,
      errorText: errorText ?? this.errorText,
      registrationInProcess:
          registrationInProcess ?? this.registrationInProcess,
    );
  }
}

class RegistratinViewModel extends ChangeNotifier {
  var usernameTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwordTec = TextEditingController();
  var repeatPasswordTec = TextEditingController();

  final _api = RepositoryModule.apiRepository();

  bool validUsername = false;
  bool validEmail = false;
  bool validPassword = false;

  BuildContext context;
  RegistratinViewModel({required this.context}) {
    usernameTec.addListener(() {
      state = state.copyWith(username: usernameTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    passwordTec.addListener(() {
      state = state.copyWith(password: passwordTec.text);
    });
    repeatPasswordTec.addListener(() {
      state = state.copyWith(repeatPassword: repeatPasswordTec.text);
    });
  }

  var _state = const _RegistrationViewModelState();
  _RegistrationViewModelState get state => _state;
  set state(_RegistrationViewModelState val) {
    _state = val;
    notifyListeners();
  }

  void showMyDatePicker() async {
    DateTime currentDate = DateTime.now();
    state = state.copyWith(
        pickedDate: await showDatePicker(
            context: context,
            initialDate: DateTime(
                currentDate.year - 14, currentDate.month, currentDate.day),
            firstDate: DateTime(1900),
            lastDate: DateTime(
                currentDate.year - 14, currentDate.month, currentDate.day)));
  }

  void registerUser(RegisterUserRequest body) async {
    var authModel = context.read<AuthViewModel>();
    await _api.registerUser(body).then((value) {
      authModel.loginTec.text = body.username;
      authModel.passwTec.text = body.password;
      authModel.login();
    });
  }

  void hidePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  bool checkFields() {
    var result = (state.username?.isNotEmpty ?? false) &&
        (state.email?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false) &&
        validEmail &&
        validUsername &&
        validPassword &&
        state.pickedDate != null;
    return result;
  }

  void showModal() {
    var ctx = AppNavigator.key.currentContext;
    if (ctx != null) {
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text("Hint!")),
            content: const Text(
                "It is allowed to use only Latin letters, numbers, underscores and dots"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        },
      );
    }
  }
}