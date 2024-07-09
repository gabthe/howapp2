// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/utils/enums.dart';

class SignUpViewmodel {
  ApiState apiState;
  GlobalKey<FormState> signUpFormKey;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  List<FocusNode> focusNodes;
  String errorMessage;
  SignUpViewmodel({
    required this.apiState,
    required this.signUpFormKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.focusNodes,
    required this.errorMessage,
  });

  SignUpViewmodel copyWith({
    ApiState? apiState,
    GlobalKey<FormState>? signUpFormKey,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    List<FocusNode>? focusNodes,
    String? errorMessage,
  }) {
    return SignUpViewmodel(
      apiState: apiState ?? this.apiState,
      signUpFormKey: signUpFormKey ?? this.signUpFormKey,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController:
          confirmPasswordController ?? this.confirmPasswordController,
      focusNodes: focusNodes ?? this.focusNodes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignUpViewmodelNotifier extends StateNotifier<SignUpViewmodel> {
  final FirebaseAuthService firebaseAuthService;
  SignUpViewmodelNotifier({required this.firebaseAuthService})
      : super(
          SignUpViewmodel(
            signUpFormKey: GlobalKey<FormState>(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            apiState: ApiState.idle,
            errorMessage: '',
            focusNodes: [
              FocusNode(),
              FocusNode(),
              FocusNode(),
            ],
          ),
        );

  createUserWithEmailAndPassword() async {
    try {
      state = state.copyWith(apiState: ApiState.pending);
      for (var focusNode in state.focusNodes) {
        focusNode.unfocus();
      }
      await firebaseAuthService.createUserWithEmailAndPassword(
        email: state.emailController.text,
        password: state.passwordController.text,
      );
      state = state.copyWith(apiState: ApiState.succeeded);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(errorMessage: _returnErrorCodeString(e.code));
      state = state.copyWith(apiState: ApiState.error);
      return;
    } catch (e, st) {
      state = state.copyWith(apiState: ApiState.error);
      log('sign_up_viewmodel_error', error: e, stackTrace: st);
    }
  }
}

final signUpViewmodelProvider =
    StateNotifierProvider.autoDispose<SignUpViewmodelNotifier, SignUpViewmodel>(
        (ref) {
  return SignUpViewmodelNotifier(
    firebaseAuthService: ref.watch(firebaseAuthServiceProvider),
  );
});

_returnErrorCodeString(String error) {
  if (error == 'email-already-in-use') {
    return 'E-mail ja foi utilizado';
  }
  return 'Erro desconhecido';
}
