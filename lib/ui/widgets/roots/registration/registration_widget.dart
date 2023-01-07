import 'package:dd_study2022_ui/ui/widgets/roots/registration/registration_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import 'package:dd_study2022_ui/domain/models/register_user_request.dart';

class RegistrationWidget extends StatelessWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<RegistratinViewModel>();
    var dtf = DateFormat("dd.MM.yyyy");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Container(
        color: Colors.grey,
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Username"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IntrinsicHeight(
                child: TextFormField(
                  controller: viewModel.usernameTec,
                  style: const TextStyle(fontSize: 15),
                  maxLength: 30,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    RegExp range1 = RegExp(r'^[a-zA-Z0-9._]+$');
                    if (value == "") {
                      viewModel.validUsername = false;
                      return "";
                    } else if (range1.hasMatch(value!)) {
                      viewModel.validUsername = true;
                      return null;
                    } else {
                      viewModel.validUsername = false;
                      return "Wrong format!";
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: viewModel.showModal,
                        child: const Icon(
                          Icons.question_mark_rounded,
                          color: Colors.black,
                          size: 18,
                        )),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(6),
                    //hintText: "enter username",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                  ),
                  showCursor: true,
                  cursorColor: Colors.black,
                ),
              ),
            ),
            const Text("Email"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IntrinsicHeight(
                child: TextFormField(
                  controller: viewModel.emailTec,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == "") {
                      viewModel.validEmail = false;
                      return "";
                    } else if (isEmail(value!)) {
                      viewModel.validEmail = true;
                      return "";
                    } else {
                      viewModel.validEmail = false;
                      return "Wrong format!";
                    }
                  },
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                  ),
                  showCursor: true,
                  cursorColor: Colors.black,
                ),
              ),
            ),
            const Text("Password"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IntrinsicHeight(
                child: TextFormField(
                  obscureText: viewModel.state.obscurePassword,
                  controller: viewModel.passwordTec,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        viewModel.hidePassword();
                      },
                      icon: Icon(viewModel.state.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(6),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                  ),
                  showCursor: true,
                  cursorColor: Colors.black,
                ),
              ),
            ),
            Container(
              height: 22,
            ),
            const Text("Repeat Password"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IntrinsicHeight(
                child: TextFormField(
                  obscureText: viewModel.state.obscurePassword,
                  controller: viewModel.repeatPasswordTec,
                  style: const TextStyle(fontSize: 15),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (viewModel.passwordTec.text ==
                        viewModel.repeatPasswordTec.text) {
                      viewModel.validPassword = true;
                      return null;
                    } else {
                      viewModel.validPassword = false;
                      return "Passwords don't match";
                    }
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                    //hintText: "enter password",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                      ),
                    ),
                  ),
                  showCursor: true,
                  cursorColor: Colors.black,
                ),
              ),
            ),
            Container(
              height: 22,
            ),
            const Text("BirthDate"),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                //color: Colors.green,
                border: Border.all(
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
              child: GestureDetector(
                onTap: () {
                  viewModel.showMyDatePicker();
                },
                child: viewModel.state.pickedDate != null
                    ? Text(dtf.format(viewModel.state.pickedDate!).toString())
                    : const Text("Set your birthdate"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: viewModel.checkFields()
                    ? () {
                        var userData = RegisterUserRequest(
                          username: viewModel.state.username!,
                          email: viewModel.state.email!,
                          password: viewModel.state.password!,
                          retryPassword: viewModel.state.repeatPassword!,
                          birthDate: viewModel.state.pickedDate!.toUtc(),
                        );
                        viewModel.registerUser(userData);
                        viewModel.state.copyWith(registrationInProcess: true);
                      }
                    : null,
                child: viewModel.state.registrationInProcess
                    ? const CircularProgressIndicator()
                    : const Text("Register"),
              ),
            )
          ],
        ),
      ),
    );
  }

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return RegistratinViewModel(context: bc);
      },
      child: const RegistrationWidget(),
    );
  }
}
