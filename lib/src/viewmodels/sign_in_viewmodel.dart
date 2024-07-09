// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/utils/enums.dart';

class SignInViewmodel {
  ApiState apiState;
  GlobalKey<FormState> signInFormKey;
  TextEditingController emailController;
  TextEditingController passwordController;
  String? signInError;
  SignInViewmodel({
    required this.apiState,
    required this.signInFormKey,
    required this.emailController,
    required this.passwordController,
    this.signInError,
  });

  SignInViewmodel copyWith({
    ApiState? apiState,
    GlobalKey<FormState>? signInFormKey,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    String? signInError,
  }) {
    return SignInViewmodel(
      apiState: apiState ?? this.apiState,
      signInFormKey: signInFormKey ?? this.signInFormKey,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      signInError: signInError ?? this.signInError,
    );
  }
}

class SignInViewmodelNotifier extends StateNotifier<SignInViewmodel> {
  final FirebaseAuthService firebaseAuthService;

  SignInViewmodelNotifier({required this.firebaseAuthService})
      : super(
          SignInViewmodel(
            apiState: ApiState.idle,
            signInFormKey: GlobalKey<FormState>(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
          ),
        );

  signInUser() async {
    try {
      state = state.copyWith(
        apiState: ApiState.pending,
        signInError: '',
      );
      await Future.delayed(const Duration(seconds: 3));

      await firebaseAuthService.signInWithEmailAndPassword(
        email: state.emailController.text.trim(),
        password: state.passwordController.text,
      );
      state = state.copyWith(apiState: ApiState.succeeded);
    } on FirebaseAuthException catch (e) {
      var errorMessage = signInErrorToString(e.code);
      state = state.copyWith(
        signInError: errorMessage,
        apiState: ApiState.error,
      );
    } catch (e, st) {
      log('sign_in_viewmodel', error: e, stackTrace: st);
      state = state.copyWith(apiState: ApiState.error);
    }
  }
}

signInErrorToString(String errorCode) {
  if (errorCode == 'invalid-credential') {
    return 'Senha ou e-mail inválido';
  }
  return 'Erro ao fazer login, tente novamente';
}

final signInViewmodelNotifierProvider =
    StateNotifierProvider.autoDispose<SignInViewmodelNotifier, SignInViewmodel>(
  (ref) {
    return SignInViewmodelNotifier(
        firebaseAuthService: ref.watch(firebaseAuthServiceProvider));
  },
);
