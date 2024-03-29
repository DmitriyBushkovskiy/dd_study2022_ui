import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/account/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy");
    var viewModel = context.watch<AccountViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.user == null ? "" : viewModel.user!.username)),
      body: viewModel.user == null ||
              viewModel.userProfile == null ||
              viewModel.currentState == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          viewModel.showChangeAvatarDialog();
                          //viewModel.changePhoto();
                        },
                        onLongPress: () {
                          viewModel.changeAvatarColor();
                        },
                        child: UserAvatarWidget(
                          user: viewModel.user,
                          radius: 41,
                        )),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Table(
                        //border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(85),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                alignment: Alignment.centerRight,
                                child: const Text("Birthday"),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                child: GestureDetector(
                                  onTap: viewModel.changeBirthdate,
                                  child: viewModel.user != null
                                      ? Text(dtf
                                          .format(viewModel
                                              .currentState!.birthdate
                                              .toLocal())
                                          .toString())
                                      : const Text("no data"),
                                ),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 12),
                                alignment: Alignment.topRight,
                                child: const Text("Email"),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    controller: viewModel.emailTec,
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      if (isEmail(value!)) {
                                        return null;
                                      } else {
                                        return "enter Email";
                                      }
                                    },
                                    style: const TextStyle(fontSize: 15),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: viewModel.emailIsNotTaken
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => {},
                                        icon: viewModel.currentState!.email ==
                                                viewModel.initialState!.email
                                            ? const SizedBox.shrink()
                                            : Icon(viewModel.emailIsNotTaken
                                                ? Icons.check
                                                : Icons.close),
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(6),
                                      hintText: "Email",
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    showCursor: true,
                                    cursorColor: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 12),
                                alignment: Alignment.topRight,
                                child: const Text("Username"),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    controller: viewModel.usernameTec,
                                    autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      RegExp range1 =
                                          RegExp(r'^[a-zA-Z0-9._]+$');
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
                                    style: const TextStyle(fontSize: 15),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: viewModel.usernameIsNotTaken
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () => {},
                                        icon: viewModel
                                                    .currentState!.username ==
                                                viewModel.initialState!.username
                                            ? const SizedBox.shrink()
                                            : Icon(viewModel.usernameIsNotTaken
                                                ? Icons.check
                                                : Icons.close),
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(6),
                                      hintText: "Email",
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    showCursor: true,
                                    cursorColor: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 12),
                                alignment: Alignment.topRight,
                                child: const Text("Phone"),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    controller: viewModel.phoneTec,
                                    // key: Key(viewModel.userProfile?.phone ??
                                    //     "no data"),
                                    // initialValue: viewModel.userProfile?.phone,
                                    style: const TextStyle(fontSize: 15),
                                    //maxLength: 100,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(6),
                                      hintText: "Phone",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    showCursor: true,
                                    cursorColor: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 12),
                                alignment: Alignment.topRight,
                                child: const Text("Full Name"),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    controller: viewModel.fullnameTec,
                                    // key: Key(viewModel.userProfile?.fullName ??
                                    //     "no data"),
                                    // initialValue:
                                    //     viewModel.userProfile?.fullName,
                                    style: const TextStyle(fontSize: 15),
                                    maxLength: 100,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(6),
                                      hintText: "enter your name",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    showCursor: true,
                                    cursorColor: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 12),
                                alignment: Alignment.topRight,
                                child: const Text("Bio"),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: IntrinsicHeight(
                                  child: TextFormField(
                                    controller: viewModel.bioTec,
                                    style: const TextStyle(fontSize: 15),
                                    maxLength: 200,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(6),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    showCursor: true,
                                    cursorColor: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (viewModel.userProfile != null)
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            if (viewModel.userProfile != null)
                              CheckboxListTile(
                                onChanged: (value) =>
                                    viewModel.onProfileStatusChanged(value!),
                                value: viewModel.currentState!.privateAccount,
                                contentPadding: const EdgeInsets.only(left: 0),
                                title: const Text(
                                  "Private Account",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ElevatedButton(
                      onPressed: viewModel.checkNewData()
                          ? viewModel.changeUserData
                          : null,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                          color: Colors.black)))),
                      child: const Text("Save changes"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) => AccountViewModel(context: context),
      child: const AccountWidget(),
    );
  }
}
