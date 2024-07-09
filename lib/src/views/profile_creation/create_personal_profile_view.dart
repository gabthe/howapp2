import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/create_personal_profile_viewmodel.dart';
import 'package:howapp2/src/viewmodels/profile_viewmodel.dart';

class CreatePersonalProfileView extends ConsumerWidget {
  const CreatePersonalProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(createPersonalProfileViewmodelProvider);
    var notifier = ref.read(createPersonalProfileViewmodelProvider.notifier);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: viewmodel.createPersonalProfileFormKey,
                      child: Column(
                        children: [
                          const Text('Criar perfil pessoal'),
                          TextFormField(
                            controller: viewmodel.displayNameController,
                            focusNode: viewmodel.displaynameFocusNode,
                            validator: (string) {
                              var value = string?.trim();

                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if (value.length > 18) {
                                return 'Nome grande demais (maximo 18 caracteres)';
                              }
                              if (value.length < 2) {
                                return 'Nome curto demais demais (minimo 2 caracteres)';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              helperText: '',
                              labelText: 'Nome',
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(viewmodel.usernameFocusNode);
                            },
                          ),
                          TextFormField(
                            controller: viewmodel.usernameController,
                            focusNode: viewmodel.usernameFocusNode,
                            validator: (string) {
                              var value = string?.trim();
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if (value.length > 18) {
                                return 'Username grande demais (maximo 18 caracteres)';
                              }
                              if (value.length < 6) {
                                return 'Username curto demais demais (minimo 6 caracteres)';
                              }
                              final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
                              if (!regex.hasMatch(value)) {
                                return 'Caracteres inválidos: apenas letras, números, "-" e "_" são permitidos';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              helperText: '',
                              suffixIcon: TextButton(
                                child: const Text('Verificar'),
                                onPressed: !viewmodel.verifiedUsername
                                    ? () {
                                        notifier.verifyUsername();
                                      }
                                    : null,
                              ),
                              errorText: viewmodel.hasUsernameError
                                  ? viewmodel.usernameErrorString
                                  : null,
                              labelText: 'Username',
                            ),
                            onChanged: (_) {
                              if (viewmodel.verifiedUsername != false) {
                                notifier.setVerifyUsernameToFalse();
                              }
                            },
                            onFieldSubmitted: (_) async {
                              var result = await notifier.verifyUsername();
                              if (result) {
                                print('Username válido');
                                FocusScope.of(context)
                                    .requestFocus(viewmodel.cityInputFocusNode);
                              } else {
                                print('Username já foi usado');
                              }
                            },
                          ),
                          TextFormField(
                            controller: viewmodel.cityInputController,
                            focusNode: viewmodel.cityInputFocusNode,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              helperText: '',
                              errorText: viewmodel.cansSendLocalizationError &&
                                      viewmodel.selectedLocalization == null
                                  ? 'Selecione sua cidade'
                                  : null,
                              labelText: 'Cidade',
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  await notifier.searchLocalization();
                                  if (viewmodel.results.isNotEmpty) {
                                    viewmodel.cityInputFocusNode.unfocus();
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                            ),
                            onFieldSubmitted: (value) async {
                              await notifier.searchLocalization();
                            },
                          ),
                          if (viewmodel.searchingLocation == ApiState.pending)
                            // loader shimmer widget todo
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          if (viewmodel.searchingLocation != ApiState.pending)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: viewmodel.results.map(
                                    (e) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: Card(
                                          color: viewmodel
                                                      .selectedLocalizationResult
                                                      ?.formattedAddress ==
                                                  e.formattedAddress
                                              ? Colors.red
                                              : Colors.blue,
                                          child: InkWell(
                                            onTap: () {
                                              notifier
                                                  .selectlocalizationResult(e);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(e.formattedAddress),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          TextButton(
                            onPressed: () async {
                              notifier.canSendLocalizationError();
                              if (viewmodel
                                  .createPersonalProfileFormKey.currentState!
                                  .validate()) {
                                try {
                                  await notifier.createPersonalProfile();
                                  ref.invalidate(profileViewmodelProvider);
                                  GoRouter.of(context).goNamed('navigator');
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: const Text('Criar perfil'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (viewmodel.creatingProfile == ApiState.pending)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Criando perfil',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          if (viewmodel.verifyingUsername == ApiState.pending)
            Center(
              child: Container(
                width: 300,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Verificando username',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
