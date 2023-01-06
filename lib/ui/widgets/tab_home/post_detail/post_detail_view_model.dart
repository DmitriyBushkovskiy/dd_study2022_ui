import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  final _dataService = DataService();
  final _syncService = SyncService();
  var descriptionTec = TextEditingController();
  var newCommentTec = TextEditingController();

  final String? postId;
  PostDetailViewModel({required this.context, this.postId}) {
    newCommentTec.addListener(() {
      comment = newCommentTec.text;
    });
    descriptionTec.addListener(() {
      newDescription = descriptionTec.text;
    });
    asyncInit();
  }

  String _newDescription = "";
  String get newDescription => _newDescription;
  set newDescription(String val) {
    _newDescription = val;
    notifyListeners();
  }

  String _comment = "";
  String get comment => _comment;
  set comment(String val) {
    _comment = val;
    notifyListeners();
  }

  bool _isChanging = false;
  bool get isChanging => _isChanging;
  set isChanging(bool val) {
    _isChanging = val;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  PostModel? _post;
  PostModel? get post => _post;
  set post(PostModel? val) {
    _post = val;
    notifyListeners();
  }

  void changeDescription() {
    descriptionTec.text = post!.description!;
    isChanging = true;
  }

  void saveChanges() {
    var newDescriptionModel = ChangePostDescriptionModel(
      postId: post!.id,
      description: newDescription,
    );
    _authService.changePostDescription(newDescriptionModel).then((value) async {
      post = await _authService.getPost(postId);
      _syncService.syncPosts([post!]);
      isChanging = false;
    });
  }

  void canselChanges() {
    isChanging = false;
  }

  void deletePost() {
    _authService.deletePost(postId!);
    Navigator.of(context).pop();
  }

  Future<void> showAlertDialogConfirmDeletingPost() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          content: const Text("Delete this post?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                deletePost();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cansel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showAlertDialogDeleteContent(int postContentIndex) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          backgroundColor: Colors.transparent,
          actions: [
            // IconButton(
            //   splashColor: Colors.transparent,
            //   highlightColor: Colors.transparent,
            //   iconSize: 60,
            //   padding: EdgeInsets.zero,
            //   color: Colors.grey,
            //   onPressed: (() {
            //     downloadFile();
            //   }),
            //   icon: const Icon(
            //     Icons.download_sharp,
            //   ),
            // ),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 60,
              padding: EdgeInsets.zero,
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop();
                deletePostContent(postContentIndex);
              },
              icon: const Icon(
                Icons.delete_forever,
              ),
            )
          ],
        );
      },
    );
  }

  String howLongAgoCreated() {
    //var createdAgo = DateTime.now(); //TODO:remove to state?
    if (post != null) {
      var now = DateTime.now().toUtc();
      var created = DateTime.parse(post!.created).toUtc();
      var createdAgo = now.subtract(Duration(
          milliseconds:
              now.millisecondsSinceEpoch - created.millisecondsSinceEpoch));
      return timeago.format(createdAgo);
    } else {
      return "";
    }
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
    post = await _authService.getPost(postId);
    post ??= await _dataService.getPost(postId!);
    if (post!.description == null) {
      post!.description = "";
    }
  }

  void deleteComment(String commentId) async {
    if (post!.comments.any((element) => element.id == commentId)) {
      _authService.deleteComment(commentId);
      post!.comments = await _authService.getComments(post!.id);
      await _syncService.syncComments(post!.comments, post!.id);
      notifyListeners();
    }
  }

  void createComment() async {
    var newComment =
        CreateCommentModel(postId: post!.id, commentText: newCommentTec.text);
    await _authService.createComment(newComment);
    post!.comments = await _authService.getComments(post!.id);
    await _syncService.syncComments(post!.comments, post!.id);
    newCommentTec.clear();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void toProfile(BuildContext bc, String userId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (__) => ProfileWidget.create(bc: bc, arg: userId)));
  }

  void likePost() async {
    var likeData = await _authService.likePost(postId);
    post!.likedByMe = likeData.likedByMe;
    post!.likes = likeData.likesAmount;
    _syncService.syncPosts([post!]);
    notifyListeners();
  }

  final ScrollController controller = ScrollController();
  void scrollDown() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void likePostContent(int postContentIndex) async {
    var content = post!.postContent[postContentIndex];
    var likeDataModel = await _authService.likeContent(content.id);
    post!.postContent[postContentIndex] = content.copyWith(
        likedByMe: likeDataModel.likedByMe, likes: likeDataModel.likesAmount);
    _syncService.syncPosts([post!]);
    notifyListeners();
  }

  void deletePostContent(int postContentIndex) async {
    var content = post!.postContent[postContentIndex];
    await _authService.deletePostContent(content.id);
    post!.postContent.remove(content);
    notifyListeners();
  }

  void downloadFile() {}
}