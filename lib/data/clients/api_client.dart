import 'dart:io';

import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// import '../../domain/models/user.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetCurrentUser")
  Future<User?> getUser();

  @GET("/api/User/GetCurrentUserData")
  Future<UserProfile?> getUserProfile();

  @GET("/api/Post/GetPostFeed")
  Future<List<PostModel>> getPostFeed(
      @Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetPostFeedByLastPostDate")
  Future<List<PostModel>> getPostFeedByLastPostDate(
      @Query("lastPostDate") String? lastPostDate);

  @POST("/api/Attach/UploadFiles")
  Future<List<AttachMeta>> uploadTemp(
      {@Part(name: "files") required List<File> files});

  @POST("/api/User/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);
}
