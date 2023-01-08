import 'dart:io';

import 'package:dd_study2022_ui/domain/models/attach_meta.dart';
import 'package:dd_study2022_ui/domain/models/change_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/change_post_description_model.dart';
import 'package:dd_study2022_ui/domain/models/change_user_data_model.dart';
import 'package:dd_study2022_ui/domain/models/chat_model.dart';
import 'package:dd_study2022_ui/domain/models/chat_request.dart';
import 'package:dd_study2022_ui/domain/models/comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_comment_model.dart';
import 'package:dd_study2022_ui/domain/models/create_message_model.dart';
import 'package:dd_study2022_ui/domain/models/create_post_model.dart';
import 'package:dd_study2022_ui/domain/models/data_by_userid_request.dart';
import 'package:dd_study2022_ui/domain/models/get_posts_request_model.dart';
import 'package:dd_study2022_ui/domain/models/like_data_model.dart';
import 'package:dd_study2022_ui/domain/models/message_model.dart';
import 'package:dd_study2022_ui/domain/models/post_model.dart';
import 'package:dd_study2022_ui/domain/models/push_token.dart';
import 'package:dd_study2022_ui/domain/models/relation_state_model.dart';
import 'package:dd_study2022_ui/domain/models/search_users_request.dart';
import 'package:dd_study2022_ui/domain/models/user.dart';
import 'package:dd_study2022_ui/domain/models/user_profile.dart';
import 'package:dd_study2022_ui/ui/widgets/roots/chat.dart';
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

  @GET("/api/Chat/GetChats")
  Future<List<ChatModel>> getChats(
    @Query("skip") int skip,
    @Query("take") int take,
  );

  @PUT("/api/Chat/GetChat")
  Future<List<MessageModel>> getChat(@Body() ChatRequest model);

  @PUT("/api/Chat/SendMessage")
  Future sendMessage(@Body() CreateMessageModel model);

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
  @GET("/api/Relation/GetRelations/{targetUserId}")
  Future<RelationStateModel> getRelations(
      @Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Follow/{targetUserId}")
  Future<String> follow(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Ban/{targetUserId}")
  Future<String> ban(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/Unban/{targetUserId}")
  Future<String> unban(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/SearchUsers")
  Future<List<User>> searchUsers(@Body() SearchUserRequest model);

  @PUT("/api/Relation/AcceptRequest/{targetUserId}")
  Future<String> acceptRequest(@Path("targetUserId") String targetUserId);

  @PUT("/api/Relation/GetFollowers")
  Future<List<User>> getFollowers(@Body() DataByUserIdRequest model);

  @PUT("/api/Relation/GetBanned")
  Future<List<User>> getBanned(@Body() DataByUserIdRequest model);

  @PUT("/api/Relation/GetFollowed")
  Future<List<User>> getFollowed(@Body() DataByUserIdRequest model);

  @PUT("/api/Relation/GetFollowersRequests")
  Future<List<User>> getFollowersRequests(@Body() DataByUserIdRequest model);

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

  @GET("/api/User/EmailIsNotTaken/{email}")
  Future<bool> checkEmailIsNotTaken(@Path("email") String email);

  @GET("/api/User/UsernameIsNotTaken/{username}")
  Future<bool> checkUsernameIsNotTaken(@Path("username") String username);

  @PUT("/api/User/ChangeUserData")
  Future changeUserData(@Body() ChangeUserDataModel model);

  // Push
  @POST("/api/Push/Subscribe")
  Future subscribe(@Body() PushToken model);

  @DELETE("/api/Push/Unsubscribe")
  Future unsubscribe();
}
