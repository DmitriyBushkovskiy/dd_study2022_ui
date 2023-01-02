import 'package:dd_study2022_ui/data/services/auth_service.dart';
import 'package:dd_study2022_ui/data/services/data_service.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/post.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/post_detail.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_profile/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _authService = AuthService();
  final _dataService = DataService();
  var commentTec = TextEditingController();

  CommentModel? _commentModel;
  CommentModel? get commentModel => _commentModel;
  set commentModel(CommentModel? val) {
    _commentModel = val;
  }

  PostModel? _post;
  PostModel? get post => _post;
  set post(PostModel? val) {
    _post = val;
    setState(() {});
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    setState(() {});
  }

  bool _isChanging = false;
  bool get isChanging => _isChanging;
  set isChanging(bool val) {
    _isChanging = val;
    setState(() {});
  }

  late String _changedCommentText;
  String get changedCommentText => _changedCommentText;
  set changedCommentText(String val) {
    _changedCommentText = val;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    commentModel = widget.comment;
    isChanging = false; //TODO:remove
    changedCommentText = commentModel!.commentText;
    commentTec.addListener(() {
      changedCommentText = commentTec.text;
    });

    asyncInit();
  }

  String howLongAgoCreated() {
    //var createdAgo = DateTime.now(); //TODO:remove to state?
    if (commentModel != null) {
      var now = DateTime.now().toUtc();
      var created = DateTime.parse(commentModel!.created).toUtc();
      var createdAgo = now.subtract(Duration(
          milliseconds:
              now.millisecondsSinceEpoch - created.millisecondsSinceEpoch));
      return timeago.format(createdAgo);
    } else {
      return "";
    }
  }

  void asyncInit() async {
    post = await _dataService.getPost(_commentModel!.postId!);
    user = await SharedPrefs.getStoredUser();
  }

  void likeComment() async {
    asyncMeth().then((value) => setState(() {}));
  }

  void deleteComment() async {
    var postDetailModel = context.read<PostDetailViewModel>();
    postDetailModel.deleteComment(commentModel!.id);
  }

  void changeComment() {
    commentTec.text = commentModel!.commentText;
    isChanging = true;
    //setState(() {});
  }

  void saveChanges() {
    var changeCommentModel = ChangeCommentModel(
      commentId: commentModel!.id,
      commentText: changedCommentText,
    );
    _authService.changeComment(changeCommentModel).then((value) => setState(() {
          commentModel = commentModel!.copyWith(
            commentText: value.commentText,
            changed: value.changed,
            likedByMe: value.likedByMe,
            likes: value.likes,
          );
          isChanging = false;
        }));
  }

  void canselChanges() {
    isChanging = false;
    //setState(() {});
  }

  Future asyncMeth() async {
    //TODO: refactoring
    var likeModel = await _authService.likeComment(commentModel!.id);
    commentModel!.likes = likeModel.likesAmount;
    commentModel!.likedByMe = likeModel.likedByMe;
  }

  // void toProfile(String userId) async {
  //       Navigator.of(context)
  //       .pushNamed(await AppNavigator.toProfile(userId));
  // }

    void toProfile(BuildContext bc, String userId) {
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => ProfileWidget.create(bc: bc, arg: userId)));

      // await Navigator.of(AppNavigator.key.currentState!.context).push(MaterialPageRoute(
      // builder: (newContext) => ProfileWidget.create(arg: userId)));
  }

  @override
  Widget build(BuildContext context) {
    return commentModel == null
        ? const SizedBox.shrink()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(
                avatar: commentModel!.author.avatarLink == null
                    ? Image.asset(
                        "assets/icons/default_avatar.png",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "$baseUrl${commentModel!.author.avatarLink}"),
                radius: 20,
                padding: 8,
                colorAvatar: commentModel!.author.colorAvatar,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => toProfile(context, commentModel!.author.id),
                              child: Text(
                                commentModel!.author.username,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            howLongAgoCreated(),
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[800]),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                          ((user != null &&
                                      user!.id == commentModel!.author.id) &&
                                  (!isChanging ||
                                      isChanging &&
                                          commentModel!.commentText !=
                                              changedCommentText))
                              ? IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.only(right: 8),
                                  onPressed:
                                      isChanging ? saveChanges : changeComment,
                                  icon: Icon(isChanging
                                      ? Icons.save_outlined
                                      : Icons.create),
                                )
                              : const SizedBox.shrink(),
                          (user != null &&
                                  (user!.id == commentModel!.author.id ||
                                      user!.id == post!.author.id))
                              ? IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.only(right: 8),
                                  onPressed: isChanging
                                      ? canselChanges
                                      : deleteComment,
                                  icon: Icon(isChanging
                                      ? Icons.close
                                      : Icons.delete_outline_outlined),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    isChanging
                        ? TextFormField(
                            controller: commentTec,
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          )
                        : Text(
                            commentModel!.commentText,
                          ),
                    Row(
                      children: [
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 8,
                          ),
                          onPressed: likeComment,
                          icon: Icon(
                              commentModel!.likedByMe
                                  ? Icons.favorite
                                  : Icons.heart_broken,
                              color: commentModel!.likedByMe
                                  ? Colors.black
                                  : Colors.grey[600]),
                        ),
                        Text(commentModel!.likes != 0
                            ? commentModel!.likes.toString()
                            : ""),
                        const Expanded(child: SizedBox.shrink()),
                        commentModel!.changed
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text("changed",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[800])),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
