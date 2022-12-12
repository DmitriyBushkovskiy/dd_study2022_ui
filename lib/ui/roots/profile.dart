// ignore_for_file: depend_on_referenced_packages

import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();

  BuildContext context;
  _ViewModel({required this.context}) {
    asyncInit();
  }

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;
  set userProfile(UserProfile? val) {
    _userProfile = val;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    userProfile = await _authService.getUserProfile();
  }

  bool colorAvatar = false;

  void changeAvatarColor() {
    colorAvatar = !colorAvatar;
    notifyListeners();
  }

  String tapChecker = "tapChecker";

  void changeText(String value) {
    tapChecker = value;
    notifyListeners();
  }

  void _showDatePicker() {
    DateTime currentDate = DateTime.now();
    showDatePicker(
        context: context,
        initialDate:
            DateTime(currentDate.year - 14, currentDate.month, currentDate.day),
        firstDate: DateTime(1900),
        lastDate: DateTime(
            currentDate.year - 14, currentDate.month, currentDate.day));
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: Text(viewModel.user == null ? "" : viewModel.user!.username)),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        viewModel.changeAvatarColor();
                      },
                      onLongPress: () {
                        viewModel.changeText("avatar - onLongPress");
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 41,
                        child: Container(
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: viewModel.user == null
                                ? null
                                : (viewModel.user!.colorAvatar == 1//TODO: костыль
                                    ? BlendMode.dstATop
                                    : BlendMode.saturation),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: viewModel.user == null
                                ? null
                                : NetworkImage(
                                    "$baseUrl${viewModel.user!.avatarLink}",
                                    headers: viewModel.headers),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.changeText("Posts");
                      },
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Posts'),
                            Text(
                              viewModel.user?.postsAmount.toString() ??
                                  "no data",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.changeText("Followers");
                      },
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Followers'),
                            Text(
                              viewModel.user?.followersAmount.toString() ??
                                  "no data",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.changeText("Followed");
                      },
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Followed'),
                            Text(
                              viewModel.user?.followedAmount.toString() ??
                                  "no data",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                              onTap: () {
                                viewModel._showDatePicker();
                              },
                              child: viewModel.user != null
                                  ? Text(DateFormat("yyyy-MM-dd")
                                      .format(DateTime.parse(
                                              viewModel.user!.birthDate)
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
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Email"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(
                                    viewModel.userProfile?.email ?? "no data"),
                                initialValue: viewModel.userProfile?.email,
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
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  hintText: "Email",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
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
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Phone"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(
                                    viewModel.userProfile?.phone ?? "no data"),
                                initialValue: viewModel.userProfile?.phone,
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
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
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
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Full Name"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                key: Key(viewModel.userProfile?.fullName ??
                                    "no data"),
                                initialValue: viewModel.userProfile?.fullName,
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
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
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
                            padding: const EdgeInsets.only(right: 6, top: 12),
                            alignment: Alignment.topRight,
                            child: const Text("Bio"),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: IntrinsicHeight(
                              child: TextFormField(
                                focusNode: FocusNode(),
                                key: Key(
                                    viewModel.userProfile?.bio ?? "no data"),
                                initialValue: viewModel.userProfile?.bio,
                                style: const TextStyle(fontSize: 15),
                                maxLength: 200,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
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
                            contentPadding: const EdgeInsets.only(left: 0),
                            title: const Text(
                              "Private Account",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: viewModel.user!.privateAccount == 1, //TODO: костыль
                            onChanged: ((value) {}),
                          ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.black)))),
                  child: const Text("Save changes"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.topLeft,
                  child: Text(
                    viewModel.tapChecker,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Profile(),
    );
  }
}
