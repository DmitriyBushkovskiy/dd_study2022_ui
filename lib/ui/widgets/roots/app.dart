import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/profile/profile_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();
  final _lvc = ScrollController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  AppViewModel({required this.context}) {
    asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!isLoading) {
          isLoading = true;
          var newPosts = <PostModel>[];
          _authService
              .getPostFeed(postFeed!.last.created)
              .then((value) => newPosts = value);
          Future.delayed(const Duration(seconds: 1)).then((value) 
          {
            postFeed = <PostModel>[...postFeed!, ...newPosts];
            isLoading = false;
          }
          );
        }
      }
    });
  }

  void toProfile(BuildContext bc) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => ProfileWidget.create(bc)));
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  List<PostModel>? _postFeed;
  List<PostModel>? get postFeed => _postFeed;
  set postFeed(List<PostModel>? val) {
    _postFeed = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    postFeed ??= await _dataService.getPosts();
    postFeed = await _authService.getPostFeed(null);
    postFeed!.insert(0, PostModel.emptyPostModel());
    avatar = (user!.avatarLink == null)
        ? Image.asset("assets/images/sadgram-logo.gif")
        : Image.network(
            "$baseUrl${user!.avatarLink}",
            key: ValueKey(const Uuid().v4()),
            fit: BoxFit.cover,
          );
  //TODO: check work without internet
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  void toPostFeedTop() {
    _lvc.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.postFeed?.length ?? 0;

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: viewModel.toPostFeedTop,
      //   child: Icon(Icons.arrow_circle_up_outlined),
      // ),
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leadingWidth: 200,
        leading: PopupMenuButton<_MenuValues>(
          onSelected: (value) {
            switch (value) {
              case _MenuValues.logout:
                viewModel._logout();
                break;
            }
          },
          color: Colors.grey,
          position: PopupMenuPosition.under,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              value: _MenuValues.logout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("logout"),
                  Icon(Icons.exit_to_app),
                ],
              ),
            ),
          ],
          child: TextButton(
            onPressed: null,
            child: Row(
              children: const [
                Text(
                  'Sadgram',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: "Fontspring",
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              AppNavigator.toChatsList();
            }),
            icon: const Icon(Icons.comment_outlined),
          ),
          IconButton(
            onPressed: (() {
              AppNavigator.toChat();
            }),
            icon: const Icon(Icons.messenger_outline_sharp),
          ),
          IconButton(
              onPressed: (() {
                AppNavigator.toCreatePostPage();
              }),
              icon: const Icon(Icons.post_add_rounded)),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: viewModel.postFeed == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      controller: viewModel._lvc,
                      itemBuilder: (listContext, listIndex) {
                        if (listIndex == 0) {
                          return Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: (viewModel.user != null &&
                                          viewModel.headers != null)
                                      ? CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 31,
                                          child: Container(
                                            foregroundDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              backgroundBlendMode: viewModel
                                                          .user ==
                                                      null
                                                  ? null
                                                  : (viewModel.user!.colorAvatar
                                                      ? BlendMode.dstATop
                                                      : BlendMode.saturation),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 0),
                                              ),
                                              height: 60,
                                              width: 60,
                                              clipBehavior: Clip.hardEdge,
                                              child: viewModel.avatar ??
                                                  const CircularProgressIndicator(),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(viewModel.user == null
                                      ? "Hi"
                                      : viewModel.user!.username),
                                )
                              ],
                            ),
                            // const Divider(
                            //   color: Colors.black,
                            //   height: 1,
                            // ),
                          ]);
                        }
                        Widget res;
                        var posts = viewModel.postFeed;
                        if (posts != null) {
                          var post = posts[listIndex];
                          res = Container(
                            padding: const EdgeInsets.all(10),
                            height: size.width,
                            color: Colors.grey,
                            child: Column(
                              children: [
                                Text(post.author.username),
                                Expanded(
                                  child: PageView.builder(
                                    onPageChanged: (value) => viewModel
                                        .onPageChanged(listIndex, value),
                                    itemCount: post.postContent.length,
                                    itemBuilder: (pageContext, pageIndex) =>
                                        Container(
                                      color: Colors.yellow,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "$baseUrl${post.postContent[pageIndex].contentLink}",
                                            headers: viewModel.headers),
                                      ),
                                    ),
                                  ),
                                ),
                                PageIndicator(
                                  count: post.postContent.length,
                                  current: viewModel.pager[listIndex],
                                ),
                                Text(post.description ?? "")
                              ],
                            ),
                          );
                        } else {
                          res = const SizedBox.shrink();
                        }
                        return res;
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                        height: 0,
                      ),
                      itemCount: itemCount,
                    ),
            ),
            if (viewModel.isLoading) const LinearProgressIndicator(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                viewModel.toProfile(context);
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
      child: const App(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}

enum _MenuValues {
  logout,
}
