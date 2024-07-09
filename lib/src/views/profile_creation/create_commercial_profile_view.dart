import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/models/commerce_type.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/create_commercial_profile_viewmodel.dart';
import 'package:howapp2/src/viewmodels/profile_viewmodel.dart';

class CreateCommercialProfile extends ConsumerWidget {
  const CreateCommercialProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(createCommercialProfileProvider);
    var notifier = ref.read(createCommercialProfileProvider.notifier);
    var width = MediaQuery.of(context).size.width;
    var height = (9 / 16) * width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: height + 60,
                        color: Colors.grey[300],
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                notifier.selectBanner(isFromCamera: false);
                              },
                              child: Container(
                                width: width,
                                height: height,
                                color: Colors.grey[300],
                                child: viewmodel.pickedBanner != null
                                    ? Image.file(
                                        File(viewmodel.pickedBanner!.path),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.photo,
                                          size: 30,
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 12,
                              child: InkWell(
                                onTap: () {
                                  notifier.selectPhoto(isFromCamera: false);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  foregroundColor: viewmodel.pickedPhoto == null
                                      ? Colors.black
                                      : Colors.transparent,
                                  backgroundImage: viewmodel.pickedPhoto != null
                                      ? FileImage(
                                          File(viewmodel.pickedPhoto!.path))
                                      : null,
                                  radius: 50,
                                  child: const Icon(Icons.photo_camera),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 115,
                              bottom: 36,
                              child: Text(
                                viewmodel.nameText.isNotEmpty
                                    ? viewmodel.nameText
                                    : 'Nome',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 115,
                              bottom: 21,
                              child: Text(
                                viewmodel.usernameText.isNotEmpty
                                    ? viewmodel.usernameText
                                    : '@nomeDeUsuario',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 115,
                              bottom: 0,
                              child: Text(
                                viewmodel.commerceType == null
                                    ? 'Tipo de estabelecimento'
                                    : viewmodel.commerceType!.commerceTypeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          onChanged: (text) {
                            notifier.updateNameText(text);
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Nome',
                            helperText: '',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          onChanged: (text) {
                            notifier.updateUsernameText(text);
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Nome de usuario',
                            helperText:
                                'O username pode conter apenas alfanuméricos, _ e .',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            notifier.selectPhoto(isFromCamera: false);
                          },
                          child: const Text('Alterar foto de perfil'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            notifier.selectBanner(isFromCamera: false);
                          },
                          child: const Text('Alterar foto de banner'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            var types = await notifier.getCommerceTypes();
                            if (context.mounted) {
                              _showDialogWithListView(
                                context,
                                types,
                                notifier,
                              );
                            }
                          },
                          child:
                              const Text('Selecionar tipo de estabelecimento'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    void showSnackBar(BuildContext context, String message) {
                      final snackBar = SnackBar(
                        content: Text(message),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    if (viewmodel.nameText.isEmpty) {
                      showSnackBar(context, 'Por favor insira um nome');
                      return;
                    }
                    if (viewmodel.usernameText.isEmpty) {
                      showSnackBar(
                          context, 'Por favor insira um nome de usuario');
                      return;
                    }
                    if (viewmodel.commerceType == null) {
                      showSnackBar(context,
                          'Por favor selecione um tipo de estabelecimento');
                      return;
                    }
                    await notifier.createCommercialProfile();
                    ref.invalidate(profileViewmodelProvider);
                    if (context.mounted) {
                      GoRouter.of(context).pop();
                    }
                  },
                  child: const Text('Criar perfil'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
          if (viewmodel.fetchingCommerceTypes == ApiState.pending)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

void _showDialogWithListView(
  BuildContext context,
  List<CommerceType> items,
  CreateCommercialProfileNotifier notifier,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: double.maxFinite,
          height: 400, // Define a height to constrain the dialog size
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Selecionar tipo de evento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].commerceTypeName),
                      onTap: () {
                        notifier.setCommerceType(items[index]);
                        GoRouter.of(context).pop();
                        // Navigator.of(context).pop();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Selected ${items[index]}'),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
