import 'dart:io';

import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/enums/relation_state.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study2022_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/cam_widget.dart';
import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/app.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/account/account.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final SyncService _syncService = SyncService();
  final DataService _dataService = DataService();
  final AuthService _authService = AuthService();
  final lvc = ScrollController();

  final BuildContext context;
  String? targetUserId;
  ProfileViewModel({required this.context, this.targetUserId}) {
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
              .getPosts(GetPostsRequestModel(
                  userId: targetUserId,
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
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      avatar = appmodel.avatar;
      user = appmodel.user;
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

  User? _targetUser;
  User? get targetUser => _targetUser;
  set targetUser(User? val) {
    _targetUser = val;
    notifyListeners();
  }

  List<PostModel>? _postFeed;
  List<PostModel>? get postFeed => _postFeed;
  set postFeed(List<PostModel>? val) {
    _postFeed = val;
    notifyListeners();
  }

  // UserProfile? _userProfile;
  // UserProfile? get userProfile => _userProfile;
  // set userProfile(UserProfile? val) {
  //   _userProfile = val;

  //   notifyListeners();
  // }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Map<String, String>? headers;

  String? _imagePath;

  Map<int, int> pager = <int, int>{};

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  RelationStateEnum? _myRelationState;
  RelationStateEnum? get myRelationState => _myRelationState;
  set myRelationState(RelationStateEnum? val) {
    _myRelationState = val;
    notifyListeners();
  }

  RelationStateEnum? _relationToMeState;
  RelationStateEnum? get relationToMeState => _relationToMeState;
  set relationToMeState(RelationStateEnum? val) {
    _relationToMeState = val;
    notifyListeners();
  }

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    targetUserId ??= user!.id;
    targetUser =
        await _dataService.getUser(targetUserId!); //TODO: is it good idea?
    myRelationState = await _authService.getMyRelationState(targetUserId!);
    relationToMeState = await _authService.getRelationToMeState(targetUserId!);
    targetUser = await _authService.getUser(targetUserId ?? user!.id);

    var t = 1;
    //userProfile = await _api.getUserProfile();

    avatar = (user!.avatarLink == null)
        ? Image.asset("assets/images/sadgram-logo.gif")
        : Image.network(
            "$baseUrl${user!.avatarLink}",
            key: ValueKey(const Uuid().v4()),
            fit: BoxFit.cover,
          );

    //postFeed ??= await _dataService.getPosts(); //TODO: get post current user
    postFeed = await _authService
        .getPosts(GetPostsRequestModel(userId: targetUserId, postsAmount: 10));
    //postFeed!.insert(0, PostModel.emptyPostModel());
  }

  void likePostContent(int listIndex, int postContentIndex) async {
    var content = postFeed![listIndex].postContent[postContentIndex];
    var likeDataModel = await _authService.likeContent(content.id);
    postFeed![listIndex].postContent[postContentIndex] = content.copyWith(
        likedByMe: likeDataModel.likedByMe, likes: likeDataModel.likesAmount);
    _syncService.syncPosts([postFeed![listIndex]]);
    notifyListeners();
  }

  Future changePhoto() async {
    var appModel = context.read<AppViewModel>();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: CamWidget(
            shape: CameraShape.circle,
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);
      }
    }

    var user = await _api.getCurrentUser();
    _syncService.syncCurrentUser(); //TODO:check it

    var img = await NetworkAssetBundle(Uri.parse("$baseUrl${user!.avatarLink}"))
        .load("$baseUrl${user.avatarLink}?v=1");
    appModel.avatar = Image.memory(
      img.buffer.asUint8List(),
      fit: BoxFit.cover,
    );
  }

  Future follow() async {
    myRelationState = await _authService.follow(targetUserId!);
    notifyListeners();
  }

  Future ban() async {
    relationToMeState = await _authService.ban(targetUserId!);
    notifyListeners();
  }

  Future unban() async {
    relationToMeState = await _authService.unban(targetUserId!);
    notifyListeners();
  }

  Future toPostDetail(String postId) async {
    await Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
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

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void showDatePickerProfile() {
    DateTime currentDate = DateTime.now();
    showDatePicker(
        context: context,
        initialDate:
            DateTime(currentDate.year - 14, currentDate.month, currentDate.day),
        firstDate: DateTime(1900),
        lastDate: DateTime(
            currentDate.year - 14, currentDate.month, currentDate.day));
  }

  // void toAccount() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (__) => AccountWidget.create()));
  // }

  void toAccount() {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.account);
  }
}
