import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app/app_view_model.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();
  final _syncService = SyncService();
  final lvc = ScrollController();

  HomeViewModel({required this.context}) {
    asyncInit();
    var appModel = context.read<AppViewModel>();
    appModel.addListener(() {
      user = appModel.user;
    });
    lvc.addListener(() {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<PostModel>? _postFeed;
  List<PostModel>? get postFeed => _postFeed;
  set postFeed(List<PostModel>? val) {
    _postFeed = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void toProfile(BuildContext bc, String userId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (__) => ProfileWidget.create(bc: bc, arg: userId)));
  }
  
  void updatePost(String postId) async {
    var updatedPost = await _dataService.getPost(postId);
    if (updatedPost == null) {
      postFeed!.remove(postFeed!.firstWhere((element) => element.id == postId));
    } else {
      var index = postFeed!
          .indexOf(postFeed!.firstWhere((element) => element.id == postId));
      postFeed![index] = updatedPost;
    }
    notifyListeners();
  }

  void likePostContent(int listIndex, int postContentIndex) async {
    var content = postFeed![listIndex].postContent[postContentIndex];
    var likeDataModel = await _authService.likeContent(content.id);
    postFeed![listIndex].postContent[postContentIndex] = content.copyWith(
        likedByMe: likeDataModel.likedByMe, likes: likeDataModel.likesAmount);
    _syncService.syncPosts([postFeed![listIndex]]);
    notifyListeners();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    postFeed ??= await _dataService.getPosts();
    postFeed = await _authService.getPostFeed(null);
    postFeed!.insert(0, PostModel.emptyPostModel());
  }

  void likePost(String postId) async {
    var likeData = await _authService.likePost(postId);
    var index = postFeed!
        .indexOf(postFeed!.firstWhere((element) => element.id == postId));
    var post = postFeed![index];
    post.likedByMe = likeData.likedByMe;
    post.likes = likeData.likesAmount;
    postFeed![index] = post;
    _syncService.syncPosts([post]);
    notifyListeners();
  }

  void logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }

  Future toPostDetail(String postId) async {
    await Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
  }
}
