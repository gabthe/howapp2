import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/sign_in_viewmodel.dart';
import 'package:howapp2/widgets/how_input_default_widget.dart';

final _obscurePasswordProvider = StateProvider<bool>((ref) {
  return true;
});

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(signInViewmodelNotifierProvider);
    var notifier = ref.read(signInViewmodelNotifierProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: viewmodel.signInFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HowInputDefault(
                  validator: (string) {
                    final RegExp emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (string == null || string.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (!emailRegex.hasMatch(string)) {
                      return 'Formato de e-mail inválido';
                    }
                    return null;
                  },
                  controller: viewmodel.emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 8),
                HowInputDefault(
                  validator: (string) {
                    if (string == null || string.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (string.length < 6) {
                      return 'Senha inválida';
                    }
                    if (string.length > 18) {
                      return 'Senha inválida';
                    }
                    return null;
                  },
                  controller: viewmodel.passwordController,
                  obscureText: ref.watch(_obscurePasswordProvider),
                  suffixIcon: IconButton(
                    onPressed: () {
                      ref.read(_obscurePasswordProvider.notifier).state =
                          !ref.watch(_obscurePasswordProvider);
                    },
                    icon: Icon(
                      ref.watch(_obscurePasswordProvider)
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  errorText: viewmodel.signInError == null ||
                          viewmodel.signInError!.isEmpty
                      ? null
                      : viewmodel.signInError,
                  labelText: 'Senha',
                ),
                if (viewmodel.apiState == ApiState.pending)
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (viewmodel.apiState != ApiState.pending)
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (viewmodel.signInFormKey.currentState!.validate()) {
                          await notifier.signInUser();
                        }
                      },
                      child: const Text('Entrar'),
                    ),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed('signUp');
                  },
                  child: const Text('Ainda não possui conta? Crie agora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
