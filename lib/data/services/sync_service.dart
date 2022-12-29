//import 'package:dd_study2022_ui/domain/models/comment.dart';
import 'package:dd_study2022_ui/domain/models/post.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
//import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/internal/config/shared_prefs.dart';
import 'package:dd_study2022_ui/internal/dependencies/repository_module.dart';
import 'data_service.dart';

class SyncService {
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();

  Future syncUser() async {
    var user = await _api.getUser();
    if (user != null) {
      await SharedPrefs.setStoredUser(user);
      await _dataService.cuUser(user);
    }
  }

  Future syncPosts(List<PostModel> postModels) async {
    var authors = postModels.map((e) => e.author).toSet();

    var commentsAuthors =
        postModels.expand((x) => x.comments.map((e) => e.author)).toSet();

    var postContents = postModels
        .expand((x) => x.postContent.map((e) => e.copyWith(postId: x.id)))
        .toList();

    var posts = postModels
        .map((e) => Post.fromJson(e.toJson()).copyWith(authorId: e.author.id))
        .toList();

    var comments = postModels
        .expand(
            (x) => x.comments.map((e) => e.toComment().copyWith(postId: x.id)))
        .toList();
        
    await _dataService.rangeUpdateEntities(commentsAuthors);
    await _dataService.rangeUpdateEntities(authors);
    await _dataService.rangeUpdateEntities(posts);
    await _dataService.rangeUpdateEntities(postContents);
    await _dataService.rangeUpdateEntities(comments);
  }
}
