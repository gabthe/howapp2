import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/sign_up_viewmodel.dart';
import 'package:howapp2/widgets/how_input_default_widget.dart';

final _passwordVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});

final _confirmPasswordVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(signUpViewmodelProvider);
    var notifier = ref.read(signUpViewmodelProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: viewmodel.signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HowInputDefault(
                  controller: viewmodel.emailController,
                  focusNode: viewmodel.focusNodes[0],
                  labelText: 'Email',
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Por favor, insira um e-mail';
                    }
                    RegExp regExp = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    );

                    if (!regExp.hasMatch(email)) {
                      return 'Por favor, insira um e-mail válido';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                HowInputDefault(
                  controller: viewmodel.passwordController,
                  focusNode: viewmodel.focusNodes[1],
                  labelText: 'Senha',
                  obscureText: ref.watch(_passwordVisibilityProvider),
                  suffixIcon: IconButton(
                    onPressed: () {
                      ref.read(_passwordVisibilityProvider.notifier).state =
                          !ref.watch(_passwordVisibilityProvider);
                    },
                    icon: ref.watch(_passwordVisibilityProvider)
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }

                    if (senha.length < 6) {
                      return 'A senha deve conter no mínimo 6 caracteres';
                    }

                    if (senha.length > 18) {
                      return 'A senha deve conter no máximo 18 caracteres';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                HowInputDefault(
                  controller: viewmodel.confirmPasswordController,
                  focusNode: viewmodel.focusNodes[2],
                  labelText: 'Confirmar senha',
                  obscureText: ref.watch(_confirmPasswordVisibilityProvider),
                  suffixIcon: IconButton(
                    onPressed: () {
                      ref
                              .read(_confirmPasswordVisibilityProvider.notifier)
                              .state =
                          !ref.watch(_confirmPasswordVisibilityProvider);
                    },
                    icon: ref.watch(_confirmPasswordVisibilityProvider)
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }

                    if (senha != viewmodel.passwordController.text) {
                      return 'Senhas não conferem';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 8),
                if (viewmodel.apiState == ApiState.pending)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (viewmodel.apiState != ApiState.pending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (viewmodel.signUpFormKey.currentState!.validate()) {
                          try {
                            await notifier.createUserWithEmailAndPassword();
                          } catch (e) {
                            log('sign_up_view_error', error: e);
                          }
                        }
                      },
                      child: const Text('Criar conta'),
                    ),
                  ),
                if (viewmodel.apiState == ApiState.error)
                  Text(
                    viewmodel.errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
