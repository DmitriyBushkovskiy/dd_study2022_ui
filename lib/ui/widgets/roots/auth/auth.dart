import 'package:dd_study2022_ui/ui/widgets/roots/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

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
                const Text("Don't you have an account yet?"),
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
        child: const AuthWidget(),
      );
}