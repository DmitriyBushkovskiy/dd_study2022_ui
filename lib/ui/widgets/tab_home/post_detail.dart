import 'dart:math' as math;

import 'package:dd_study2022_ui/data/services/sync_service.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/comment_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/home.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/post.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/token_storage.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/page_indicator.dart';

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
    //setState(() {});
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
    }); //TODO: обновление поста в ленте
    // var appmodel = context.read<HomeViewModel>();
    // appmodel.postFeed?.firstWhere((element) => element.id == post!.id).description = post!.description;
  }

  void canselChanges() {
    isChanging = false;
  }

  void deletePost() {
    //TODO; make this method private
    Navigator.of(context).pop();
    _authService.deletePost(postId!);
    isChanging = false; //TODO: remove post from
  }

  Future<void> showAlertDialogConfirmDeletingPost() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          //title: const Text('Basic dialog title'),
          content: const Text("Delete this post?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deletePost();
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

  Future<void> showAlertDialogDownloadOrDeleteContent(int postContentIndex) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 60,
              padding: EdgeInsets.zero,
              color: Colors.grey,
              onPressed: (() {
                downloadFile();
              }),
              icon: const Icon(
                Icons.download_sharp,
              ),
            ),
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

  // List<CommentWidget> getComments() {
  //   var result = (post != null && post!.comments.isNotEmpty)
  //       ? post!.comments
  //           .map((e) => CommentWidget(
  //                 comment: e,
  //               ))
  //           .toList()
  //       : <CommentWidget>[];
  //   return result;
  // }

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

  void deleteComment(String id) {
    if (post!.comments.any((element) => element.id == id)) {
      var comments = post!.comments;
      var comment = comments.firstWhere((element) => element.id == id);
      comments.remove(comment);
      post = post!.copyWith(comments: comments);
      //post = post; //TODO: kostil
      notifyListeners();
    }
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }


  void likePost() async {
    var likeData = await _authService.likePost(postId);
    post!.likedByMe = likeData.likedByMe;
    post!.likes = likeData.likesAmount;
    notifyListeners();
  }

  void createComment() async {
    var newComment =
        CreateCommentModel(postId: post!.id, commentText: newCommentTec.text);
    await _authService.createComment(newComment);
    post!.comments = await _authService.getComments(post!.id);
    newCommentTec.clear();
    //notifyListeners();
  }

  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void likePostContent(int postContentIndex) async {
    var content = post!.postContent[postContentIndex];
    var likeDataModel = await _authService.likeContent(content.id);
    post!.postContent[postContentIndex] = content.copyWith(
        likedByMe: likeDataModel.likedByMe, likes: likeDataModel.likesAmount);
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

class PostDetail extends StatelessWidget {
  const PostDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PostDetailViewModel>();
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(),
        body: viewModel.post != null
            ? SafeArea(
                child: ListView(
                  controller: viewModel._controller,
                  shrinkWrap: true,
                  children: <Widget>[
                    AuthorAvatarAndNameWidget(
                      avatarWidget: AvatarWidget(
                        avatar: viewModel.post!.author.avatarLink == null
                            ? Image.asset(
                                "assets/icons/default_avatar.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "$baseUrl${viewModel.post!.author.avatarLink}"),
                        radius: 20,
                        colorAvatar: viewModel.post!.author.colorAvatar,
                        padding: 10,
                      ),
                      user: viewModel.post!.author,
                    ),
                    Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          SizedBox(
                            height: size.width,
                            child: PageView.builder(
                              onPageChanged: (value) =>
                                  viewModel.onPageChanged(0, value),
                              itemCount: viewModel.post!.postContent.length,
                              itemBuilder: (_, pageIndex) => SizedBox(
                                height: size.width,
                                //color: Colors.yellow,
                                child: GestureDetector(
                                  onLongPress: () {
                                    viewModel
                                        .showAlertDialogDownloadOrDeleteContent(
                                            pageIndex);
                                  },
                                  onTap: () {
                                    viewModel.likePostContent(pageIndex);

                                    //TODO: make method like image
                                  },
                                  child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      children: [
                                        Container(
                                          foregroundDecoration: BoxDecoration(
                                            color: Colors.grey,
                                            backgroundBlendMode: (viewModel
                                                    .post!
                                                    .postContent[pageIndex]
                                                    .likedByMe
                                                ? BlendMode.dstATop
                                                : BlendMode.saturation),
                                          ),
                                          width: size.width,
                                          height: size.width,
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "$baseUrl${viewModel.post!.postContent[pageIndex].contentLink}",
                                                headers: viewModel.headers),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                //color: Colors.amber,
                                                height: 35,
                                                width: 35,
                                                child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.favorite_sharp,
                                                        size: 30,
                                                      ),
                                                      Icon(
                                                        viewModel
                                                                .post!
                                                                .postContent[
                                                                    pageIndex]
                                                                .likedByMe
                                                            ? Icons
                                                                .favorite_sharp
                                                            : Icons
                                                                .heart_broken_sharp,
                                                        color: Colors.white,
                                                      )
                                                    ])),
                                            viewModel
                                                        .post!
                                                        .postContent[pageIndex]
                                                        .likes ==
                                                    0
                                                ? SizedBox.shrink()
                                                : Stack(
                                                    children: <Widget>[
                                                      // Stroked text as border.
                                                      Text(
                                                        viewModel
                                                            .post!
                                                            .postContent[
                                                                pageIndex]
                                                            .likes
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          foreground: Paint()
                                                            ..style =
                                                                PaintingStyle
                                                                    .stroke
                                                            ..strokeWidth = 4
                                                            ..color =
                                                                Colors.black,
                                                        ),
                                                      ),
                                                      // Solid text as fill.
                                                      Text(
                                                        viewModel
                                                            .post!
                                                            .postContent[
                                                                pageIndex]
                                                            .likes
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          PageIndicator(
                            count: viewModel.post!.postContent.length,
                            current: viewModel.pager[0],
                          ),
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            viewModel.post!.author.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          viewModel.howLongAgoCreated(),
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[800]),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        ((viewModel.user != null &&
                                    viewModel.user!.id ==
                                        viewModel.post!.author.id) &&
                                (!viewModel.isChanging ||
                                    viewModel.isChanging &&
                                        viewModel.post!.description !=
                                            viewModel.newDescription))
                            ? IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                onPressed: viewModel.isChanging
                                    ? viewModel.saveChanges
                                    : viewModel.changeDescription,
                                icon: Icon(viewModel.isChanging
                                    ? Icons.save_outlined
                                    : Icons.create),
                              )
                            : const SizedBox.shrink(),
                        (viewModel.user != null &&
                                viewModel.user!.id == viewModel.post!.author.id)
                            ? IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                onPressed: viewModel.isChanging
                                    ? viewModel.canselChanges
                                    : viewModel
                                        .showAlertDialogConfirmDeletingPost,
                                icon: Icon(viewModel.isChanging
                                    ? Icons.close
                                    : Icons.delete_outline_outlined),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: viewModel.isChanging
                          ? TextFormField(
                              controller: viewModel.descriptionTec,
                              style: const TextStyle(fontSize: 14),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            )
                          : (viewModel.post!.description == ""
                              ? const SizedBox.shrink()
                              : Text(viewModel.post!.description!)),
                    ),
                    Row(children: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: viewModel.likePost,
                        icon: Icon(
                          viewModel.post!.likedByMe
                              ? Icons.favorite
                              : Icons.heart_broken,
                          color: viewModel.post!.likedByMe
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                      Text(viewModel.post!.likes == 0
                          ? ""
                          : viewModel.post!.likes.toString()),
                      const SizedBox(width: 20),
                      viewModel.post!.comments.isEmpty
                          ? const SizedBox.shrink() //TODO: change to iconButton
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: viewModel._scrollDown,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child:
                                      const Icon(Icons.mode_comment_outlined),
                                ),
                              ),
                            ),
                      Text(viewModel.post!.comments.isEmpty
                          ? ""
                          : viewModel.post!.comments.length.toString()),
                      const Expanded(child: SizedBox.shrink()),
                      viewModel.post!.changed
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text("changed",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[800])),
                            )
                          : const SizedBox.shrink()
                    ]),
                    viewModel.post!.comments.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 16, top: 16),
                            child: Text("Comments:"),
                          )
                        : SizedBox.shrink(),
                    ListView.separated(
                      key: Key(viewModel.post!.comments.length.toString()),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.post!.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommentWidget(
                            comment: viewModel.post!.comments[index]
                                .copyWith(postId: viewModel.postId));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: viewModel.newCommentTec,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ),
                          viewModel.comment != ""
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      size: 37,
                                    ),
                                    onPressed: viewModel.createComment,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),

                //Text(viewModel.postId ?? "empty"),
              )
            : const Center(child: Text("Post not found!")));
  }

  static create(Object? arg) {
    String? postId;
    if (arg != null && arg is String) postId = arg;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          PostDetailViewModel(context: context, postId: postId),
      child: const PostDetail(),
    );
  }
}

class AuthorAvatarAndNameWidget extends StatelessWidget {
  //final HomeViewModel viewModel;
  final User user;
  final AvatarWidget avatarWidget;

  const AuthorAvatarAndNameWidget(
      {Key? key, required this.avatarWidget, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Row(
        children: [
          avatarWidget,
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: Text(user.username),
            ),
          )
        ],
      ),
    );
  }
}
