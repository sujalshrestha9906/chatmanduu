import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:chatmandu/model/common_state.dart';
import 'package:chatmandu/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final authStream =
    StreamProvider((ref) => FirebaseInstances.firebaseAuth.authStateChanges());

final authProvider = StateNotifierProvider<AuthProvider, CommonState>((ref) =>
    AuthProvider(CommonState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));

class AuthProvider extends StateNotifier<CommonState> {
  AuthProvider(super.state);

  Future<void> userSignUp(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userSignUp(
        email: email, password: password, username: username, image: image);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  Future<void> userLogOut() async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogOut();
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }
}
