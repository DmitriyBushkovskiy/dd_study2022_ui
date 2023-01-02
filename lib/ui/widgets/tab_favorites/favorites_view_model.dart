import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/navigation/tab_navigator.dart';
import 'package:flutter/material.dart';

class FavoritesViewModel extends ChangeNotifier {
  // final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();
  final DataService _dataService = DataService();
  final AuthService _authService = AuthService();
  final lvc = ScrollController();

  final BuildContext context;
  FavoritesViewModel({required this.context}) {
    asyncInit();
    

lvc.addListener(() {
      var max = lvc.position.maxScrollExtent;
      var current = lvc.offset;
      var distanceToEnd = max - current;
      if (distanceToEnd < 1000) {
        if (!isLoading) {
          isLoading = true;
          var newPosts = <PostModel>[];
          _authService
              .getFavoritePosts(GetPostsRequestModel(
                  postsAmount: 10,
                  lastPostDate: postFeed!.last.created))
              .then((value) => newPosts = value);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            postFeed = <PostModel>[...postFeed!, ...newPosts];
            isLoading = false;
          });
        }
      }
    });

  }

  void likePostContent(int listIndex, int postContentIndex) async {
    var content = postFeed![listIndex].postContent[postContentIndex];
    var likeDataModel = await _authService.likeContent(content.id);
    postFeed![listIndex].postContent[postContentIndex] = content.copyWith(
        likedByMe: likeDataModel.likedByMe, likes: likeDataModel.likesAmount);
    _syncService.syncPosts([postFeed![listIndex]]);
    notifyListeners();
  }

    Future toPostDetail(String postId) async {
    await Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
  }

  void updatePost(String postId) async {
    var updatedPost = await _dataService.getPost(postId);
    if (updatedPost == null || !updatedPost.likedByMe) {
      postFeed!.remove(postFeed!.firstWhere((element) => element.id == postId));
    } else {
      var index = postFeed!
          .indexOf(postFeed!.firstWhere((element) => element.id == postId));
      postFeed![index] = updatedPost;
    }
    notifyListeners();
  }

    void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<PostModel>? _postFeed;
  List<PostModel>? get postFeed => _postFeed;
  set postFeed(List<PostModel>? val) {
    _postFeed = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  Map<String, String>? headers;

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    // user = await SharedPrefs.getStoredUser();
    // targetUserId ??= user!.id;
    // targetUser =
    //     await _dataService.getUser(targetUserId!); //TODO: is it good idea?
    // myRelationState = await _authService.getMyRelationState(targetUserId!);
    // relationToMeState = await _authService.getRelationToMeState(targetUserId!);
    // targetUser = await _authService.getUser(targetUserId ?? user!.id);

    // var t = 1;

    // avatar = (user!.avatarLink == null)
    //     ? Image.asset("assets/images/sadgram-logo.gif")
    //     : Image.network(
    //         "$baseUrl${user!.avatarLink}",
    //         key: ValueKey(const Uuid().v4()),
    //         fit: BoxFit.cover,
    //       );

    postFeed = await _authService
        .getFavoritePosts(GetPostsRequestModel(postsAmount: 10));
  }
  
}
