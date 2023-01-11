import 'dart:math' as math;

import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/changed_label_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/comments_icon_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/like_icon_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/post_content_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/comment/comment_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/tab_home/post_detail/post_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dd_study2022_ui/ui/widgets/common/page_indicator.dart';

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
                  controller: viewModel.controller,
                  shrinkWrap: true,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => viewModel.toProfile(
                          context, viewModel.post!.author.id),
                      child: AvatarWithNameWidget(
                        avatarRadius: 20,
                        user: viewModel.post!.author,
                      ),
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
                                child: GestureDetector(
                                    onLongPress: () {
                                      viewModel.showAlertDialogDeleteContent(
                                          pageIndex);
                                    },
                                    onTap: () {
                                      viewModel.likePostContent(pageIndex);
                                    },
                                    child: PostContentWidget(
                                      headers: viewModel.headers!,
                                      contentLink: viewModel.post!
                                          .postContent[pageIndex].contentLink,
                                      likedByMe: viewModel.post!
                                          .postContent[pageIndex].likedByMe,
                                      likesAmount: viewModel
                                          .post!.postContent[pageIndex].likes,
                                    )),
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
                      padding: const EdgeInsets.all(8),
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
                          icon: LikeIconWidget(
                            likedByMe: viewModel.post!.likedByMe,
                          )),
                      Text(viewModel.post!.likes == 0
                          ? ""
                          : viewModel.post!.likes.toString()),
                      const SizedBox(width: 20),
                      viewModel.post!.comments.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: viewModel.scrollDown,
                              icon: const CommentsIconWidget()),
                      Text(viewModel.post!.comments.isEmpty
                          ? ""
                          : viewModel.post!.comments.length.toString()),
                      const Expanded(child: SizedBox.shrink()),
                      ChangedLabelWidget(changed: viewModel.post!.changed)
                    ]),
                    viewModel.post!.comments.isNotEmpty
                        ? const Padding(
                            padding:
                                EdgeInsets.only(left: 8, bottom: 16, top: 16),
                            child: Text("Comments:"),
                          )
                        : const SizedBox.shrink(),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 40,
                                maxWidth: 320,
                                maxHeight: 150,
                              ),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: viewModel.newCommentTec,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 212, 212, 212),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      size: 30,
                                    ),
                                    onPressed: viewModel.createComment,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()));
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
