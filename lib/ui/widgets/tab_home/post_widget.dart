import 'package:dd_study2022_ui/internal/config/app_config.dart';
import 'package:dd_study2022_ui/ui/widgets/common/avatar_with_name_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/changed_label_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/comments_icon_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/content_like_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/like_icon_widget.dart';
import 'package:dd_study2022_ui/ui/widgets/common/page_indicator.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final dynamic viewModel;
  final int listIndex;

  const PostWidget({Key? key, required this.viewModel, required this.listIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget result;
    var posts = viewModel.postFeed;
    if (posts != null) {
      var post = posts[listIndex];
      result = GestureDetector(
        onTap: () => viewModel
            .toPostDetail(post.id)
            .then((value) => viewModel.updatePost(post.id)),
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => viewModel.toProfile(context, post.author!.id),
                child: AvatarWithNameWidget(
                  avatarRadius: 20,
                  user: post.author,
                ),
              ),
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                SizedBox(
                  height: size.width,
                  child: PageView.builder(
                    onPageChanged: (value) =>
                        viewModel.onPageChanged(listIndex, value),
                    itemCount: post.postContent.length,
                    itemBuilder: (_, pageIndex) => SizedBox(
                      height: size.width,
                      child: GestureDetector(
                        onTap: () {
                          viewModel.likePostContent(listIndex, pageIndex);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              Container(
                                foregroundDecoration: BoxDecoration(
                                  color: Colors.grey,
                                  backgroundBlendMode:
                                      (post!.postContent[pageIndex].likedByMe
                                          ? BlendMode.dstATop
                                          : BlendMode.saturation),
                                ),
                                width: size.width,
                                height: size.width,
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "$baseUrl${post!.postContent[pageIndex].contentLink}",
                                      headers: viewModel.headers),
                                ),
                              ),
                              ContentLikeCounter(
                                  likedByMe:
                                      post!.postContent[pageIndex].likedByMe,
                                  likesAmount:
                                      post!.postContent[pageIndex].likes)
                            ]),
                      ),
                    ),
                  ),
                ),
                PageIndicator(
                  count: post.postContent.length,
                  current: viewModel.pager[listIndex],
                ),
              ]),
              Row(children: [
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    onPressed: () => viewModel.likePost(post.id),
                    icon: LikeIconWidget(
                      likedByMe: post!.likedByMe,
                    )),
                Text(post!.likes == 0 ? "" : post!.likes.toString()),
                const SizedBox(width: 20),
                post!.comments.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () {}, icon: const CommentsIconWidget()),
                Text(post!.comments.isEmpty
                    ? ""
                    : post!.comments.length.toString()),
                const Expanded(child: SizedBox.shrink()),
                ChangedLabelWidget(changed: post!.changed)
              ]),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: post.description == ""
                    ? const SizedBox.shrink()
                    : Text(
                        post!.description?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
              ),
              const SizedBox(height: 16,)
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