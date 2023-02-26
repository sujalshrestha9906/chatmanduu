import 'package:chatmandu/model/common_state.dart';
import 'package:chatmandu/model/post.dart';
import 'package:chatmandu/services/post_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

final postProvider = StateNotifierProvider<PostProvider, CommonState>((ref) =>
    PostProvider(CommonState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));

class PostProvider extends StateNotifier<CommonState> {
  PostProvider(super.state);

  Future<void> postAdd(
      {required String title,
      required String detail,
      required String userId,
      required XFile image}) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.postAdd(
        title: title, detail: detail, userId: userId, image: image);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  Future<void> postUpdate(
      {required String title,
      required String detail,
      required String postId,
      String? imageId,
      XFile? image}) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.postUpdate(
        title: title,
        detail: detail,
        postId: postId,
        image: image,
        imageId: imageId);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  Future<void> addLike(List<String> usernames, String postId, int like) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.addLike(usernames, postId, like);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  Future<void> addComment(List<Comment> comments, String postId) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await PostService.addComment(comments, postId);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }
}
