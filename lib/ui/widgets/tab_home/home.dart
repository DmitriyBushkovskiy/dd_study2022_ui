import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';

class HomeViewModel extends ChangeNotifier {
  //TODO: make private?
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

  HomeViewModel({required this.context}) {
    asyncInit();
    var appModel = context.read<AppViewModel>();
    appModel.addListener(() {
      avatar = appModel.avatar;
    });
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
          Future.delayed(const Duration(seconds: 1)).then((value) {
            postFeed = <PostModel>[...postFeed!, ...newPosts];
            isLoading = false;
          });
        }
      }
    });
  }

  // void toProfile(BuildContext bc) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (__) => ProfileWidget.create(bc)));
  // }

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
        ? Image.asset("assets/icons/default_avatar.png")
        : Image.network(
            "$baseUrl${user!.avatarLink}",
            key: ValueKey(const Uuid().v4()),
            fit: BoxFit.cover,
          );
    //TODO: check work without internet
  }

  // void updatePost(PostModel post){ //TODO: updete postFeed after change comments ammount
  //   if(postFeed!.any((element) => element.id == post.id)){
  //     var oldPost = postFeed!.firstWhere((element) => element.id == post.id);
  //     postFeed!.remove(oldPost);
  //     postFeed!.add(post);
  //     notifyListeners();
  //   }
  // }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  // void toPostFeedTop() {
  //   _lvc.animateTo(0,
  //       duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  // }

  Future toPostDetail(String postId) async {
    await Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.postFeed?.length ?? 0;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: viewModel.postFeed == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: viewModel._lvc,
                    itemBuilder: (_, listIndex) {
                      if (listIndex == 0) {
                        return FirstInFeedWidget(viewModel: viewModel);
                      } else {
                        return PostInFeedWidget(
                          viewModel: viewModel,
                          listIndex: listIndex,
                        );
                      }
                      // Widget res;
                      // var posts = viewModel.postFeed;
                      // if (posts != null) {
                      //   var post = posts[listIndex];
                      //   res = GestureDetector(
                      //     onTap: () => viewModel.toPostDetail(post.id),
                      //     child: Container(
                      //       padding: const EdgeInsets.all(10),
                      //       height: size.width,
                      //       color: Colors.grey,
                      //       child: Column(
                      //         children: [
                      //           Text(post.author.username),
                      //           Expanded(
                      //             child: PageView.builder(
                      //               onPageChanged: (value) => viewModel
                      //                   .onPageChanged(listIndex, value),
                      //               itemCount: post.postContent.length,
                      //               itemBuilder: (_, pageIndex) => Container(
                      //                 color: Colors.yellow,
                      //                 child: Image(
                      //                   fit: BoxFit.cover,
                      //                   image: NetworkImage(
                      //                       "$baseUrl${post.postContent[pageIndex].contentLink}",
                      //                       headers: viewModel.headers),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           PageIndicator(
                      //             count: post.postContent.length,
                      //             current: viewModel.pager[listIndex],
                      //           ),
                      //           Text(post.description ?? "")
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      // } else {
                      //   res = const SizedBox.shrink();

                      // }
                      // return res;
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    itemCount: itemCount,
                  ),
          ),
          if (viewModel.isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeViewModel(context: context),
      child: const Home(),
    );
  }
}

class PostInFeedWidget extends StatelessWidget {
  final HomeViewModel viewModel;
  final int listIndex;

  const PostInFeedWidget(
      {Key? key, required this.viewModel, required this.listIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget result;
    var posts = viewModel.postFeed;
    if (posts != null) {
      var post = posts[listIndex];
      result = GestureDetector(
        onTap: () => viewModel.toPostDetail(post.id).then((value) async {
          viewModel.asyncInit();
        }),
        child: Container(
          //padding: const EdgeInsets.all(10),
          //height: size.width,
          color: Colors.grey,
          child: Column(
            children: [
              Text(post.author.username),
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                SizedBox(
                  height: size.width,
                  child: PageView.builder(
                    onPageChanged: (value) =>
                        viewModel.onPageChanged(listIndex, value),
                    itemCount: post.postContent.length,
                    itemBuilder: (_, pageIndex) => SizedBox(
                      height: size.width,
                      //color: Colors.yellow,
                      child: GestureDetector(
                        onTap: () {
                          //TODO: make method like image
                        },
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "$baseUrl${post.postContent[pageIndex].contentLink}",
                              headers: viewModel.headers),
                        ),
                      ),
                    ),
                  ),
                ),
                PageIndicator(
                  count: post.postContent.length,
                  current: viewModel.pager[listIndex],
                ),
              ]),
              post.description != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(post.description ?? "",
                          maxLines: 5, overflow: TextOverflow.ellipsis),
                    )
                  : const SizedBox.shrink(),
              Text("Comments ${post.comments.length}")
            ],
          ),
        ),
      );
    } else {
      result = const SizedBox.shrink();
    }
    return result;
  }
}

class FirstInFeedWidget extends StatelessWidget {
  final HomeViewModel viewModel;

  const FirstInFeedWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: [
          viewModel.user != null
              ? AvatarWidget(
                  avatar: viewModel.avatar ??
                      Image.asset(
                        "assets/icons/default_avatar.png",
                        fit: BoxFit.cover,
                      ),
                  padding: 10,
                  radius: 31,
                  colorAvatar: false, // TODO: viewmodel.user
                )
              : const CircularProgressIndicator(),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: viewModel._logout, //TODO: remove
              child: Text(viewModel.user == null
                  ? "no data"
                  : viewModel.user!.username),
            ),
          )
        ],
      ),
    );
  }
}

// class PageIndicator extends StatelessWidget {
//   //TODO: remove to own file
//   final int count;
//   final int? current;
//   final double width;
//   const PageIndicator(
//       {Key? key, required this.count, required this.current, this.width = 10})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> widgets = <Widget>[];
//     for (var i = 0; i < count; i++) {
//       widgets.add(
//         Icon(
//           Icons.circle,
//           size: i == (current ?? 0) ? width * 1.4 : width,
//         ),
//       );
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [...widgets],
//     );
//   }
// }
