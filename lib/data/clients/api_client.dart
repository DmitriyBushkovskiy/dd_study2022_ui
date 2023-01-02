import 'dart:io';

import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

//Attach

  @POST("/api/Attach/UploadFiles")
  Future<List<AttachMeta>> uploadTemp(
      {@Part(name: "files") required List<File> files});

//Chat

//Post

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel model);

  @GET("/api/Post/GetPost/{postId}")
  Future<PostModel> getPost(@Path("postId") String? postId);

  @GET("/api/Post/GetPostFeedByLastPostDate")
  Future<List<PostModel>> getPostFeedByLastPostDate(
      @Query("lastPostDate") String? lastPostDate);

  @PUT("/api/Post/GetPostsByLastPostDate")
  Future<List<PostModel>> getPostsByLastPostDate(
      @Body() GetPostsRequestModel model);

  @PUT("/api/Post/GetFavoritePosts")
  Future<List<PostModel>> getFavoritePosts(@Body() GetPostsRequestModel model);

  @PUT("/api/Post/ChangePostDescription")
  Future changePostDescription(@Body() ChangePostDescriptionModel model);

  @PUT("/api/Post/LikePost/{postId}")
  Future<LikeDataModel> likePost(@Path("postId") String? postId);

  @DELETE("/api/Post/DeletePost/{postId}")
  Future deletePost(@Path("postId") String postId);

  @POST("/api/Post/CreateComment")
  Future createComment(@Body() CreateCommentModel model);

  @GET("/api/Post/GetComments/{postId}")
  Future<List<CommentModel>> getComments(@Path("postId") String postId);

  @PUT("/api/Post/ChangeComment")
  Future<CommentModel> changeComment(@Body() ChangeCommentModel model);

  @PUT("/api/Post/LikeComment/{commentId}")
  Future<LikeDataModel> likeComment(@Path("commentId") String? commentId);

  @DELETE("/api/Post/DeleteComment/{commentId}")
  Future deleteComment(@Path("commentId") String? commentId);

  @PUT("/api/Post/LikeContent/{contentId}")
  Future<LikeDataModel> likeContent(@Path("contentId") String contentId);

  @DELETE("/api/Post/DeletePostContent/{contentId}")
  Future deletePostContent(@Path("contentId") String contentId);

//Relation
  @GET("/api/Relation/GetMyRelationState/{targetUserId}")
  Future<String> getMyRelationState(@Path("targetUserId") String targetUserId);

  @GET("/api/Relation/GetRelationToMeState/{targetUserId}")
  Future<String> getRelationToMeState(
      @Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Follow/{targetUserId}")
  Future<String> follow(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Ban/{targetUserId}")
  Future<String> ban(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Unban/{targetUserId}")
  Future<String> unban(@Path("targetUserId") String targetUserId);

//User

  @POST("/api/User/AddAvatarToUser")
  Future addAvatarToUser(@Body() AttachMeta model);

  @PUT("/api/User/ChangeAvatarColor")
  Future<bool> changeAvatarColor();

  @GET("/api/User/GetUser/{targetUserId}")
  Future<User?> getUser(@Path("targetUserId") String targetUserId);

  @GET("/api/User/GetCurrentUser")
  Future<User?> getCurrentUser();

  @GET("/api/User/GetCurrentUserData")
  Future<UserProfile?> getUserProfile();

  // @GET("/api/Post/GetPostFeed") //TODO: remove?
  // Future<List<PostModel>> getPostFeed(
  //     @Query("skip") int skip, @Query("take") int take);
}
