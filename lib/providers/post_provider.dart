import 'package:chatmandu/model/common_state.dart';
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
}
