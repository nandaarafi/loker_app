import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lokerapps/features/data/auth_remote_data_service.dart';
import 'package:lokerapps/features/data/auth_remote_data_source.dart';

import '../../../domain/auth_data_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signInRole({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      UserModel user = await AuthRemoteDataSource().signIn(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthException(e);
      emit(AuthFailed((errorMessage)));
    }
  }

  void signUp({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      UserModel user = await AuthRemoteDataSource().signUp(
        email: email,
        password: password,
      );

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleAuthException(e);
      emit(AuthFailed(errorMessage));
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'Wrong Password or Email';
      case 'too-many-requests':
        return 'Too many request, Please Try Again';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return e.code;
    }
  }

  void signOut() async {
    try {
      await AuthRemoteDataSource().signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void getCurrentUser(String id) async {
    try {
      UserModel user = await AuthRemoteDataService().getUserById(id);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
