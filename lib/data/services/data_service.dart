import 'package:dd_study2022_ui/data/services/database.dart';
import 'package:dd_study2022_ui/domain/db_model.dart';
import 'package:dd_study2022_ui/domain/models/comment.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/post.dart';
import 'package:dd_study2022_ui/domain/models/post_content.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';

class DataService {
  Future cuUser(User user) async {
    await DB.instance.createUpdate(user);
  }

  Future rangeUpdateEntities<T extends DbModel>(Iterable<T> elems) async {
    await DB.instance.createUpdateRange(elems);
  }

  Future<List<PostModel>> getPosts() async {
    //TODO: rename to getPostFeed
    var res = <PostModel>[];
    var posts = await DB.instance.getAll<Post>(); //TODO: itterations
    for (var post in posts) {
      var author = await DB.instance.get<User>(post.authorId);
      var contents =
          (await DB.instance.getAll<PostContent>(whereMap: {"postId": post.id}))
              .toList(); //TODO: add comments, add comment model

      var comments =
          (await DB.instance.getAll<Comment>(whereMap: {"postId": post.id}))
              .toList();

      var commentModels = <CommentModel>[];
      for (var comment in comments) {
        var commentAuthor = await DB.instance.get<User>(comment.authorId);
        if (commentAuthor != null) {
          commentModels.add(CommentModel(
            id: comment.id,
            commentText: comment.commentText,
            created: comment.created,
            changed: comment.changed,
            author: commentAuthor,
            likes: comment.likes,
            likedByMe: comment.likedByMe,
          ));
        }
      }

      if (author != null) {
        res.add(PostModel(
          //TODO: make constructor - from Post
          id: post.id,
          description: post.description,
          created: post.created,
          changed: post.changed,
          likes: post.likes,
          likedByMe: post.likedByMe,
          author: author,
          postContent: contents,
          comments: commentModels,
        ));
      }
    }
    res.sort((a, b) => b.created.compareTo(a.created));
    return res;
  }

  Future<PostModel?> getPost(String id) async {
    var post = await DB.instance.get<Post>(id);
    if (post != null && post.authorId != null) {
      var author = await DB.instance.get<User>(post.authorId);
      if (author == null) {
        return null;
      }
      var contents =
          (await DB.instance.getAll<PostContent>(whereMap: {"postId": post.id}))
              .toList(); //TODO: add comments, add comment model

      var comments =
          (await DB.instance.getAll<Comment>(whereMap: {"postId": post.id}))
              .toList();

      var commentModels = <CommentModel>[];
      for (var comment in comments) {
        var commentAuthor = await DB.instance.get<User>(comment.authorId);
        if (commentAuthor != null) {
          commentModels.add(CommentModel(
            id: comment.id,
            commentText: comment.commentText,
            created: comment.created,
            changed: comment.changed,
            author: commentAuthor,
            likes: comment.likes,
            likedByMe: comment.likedByMe,
          ));
        }
      }

      var result = PostModel(
        //TODO: make constructor - from Post
        id: post.id,
        description: post.description,
        created: post.created,
        changed: post.changed,
        likes: post.likes,
        likedByMe: post.likedByMe,
        author: author,
        postContent: contents,
        comments: commentModels,
      );
      return result;
    } else {
      return null;
    }
  }
}
