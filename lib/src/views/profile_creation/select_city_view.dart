import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:howapp2/src/models/localization.dart';
import 'package:howapp2/src/repositories/location_repository.dart';
import 'package:howapp2/src/viewmodels/create_commercial_profile_viewmodel.dart';

final _localizationStateProvider = StateProvider<Localization?>((ref) {
  return null;
});

final _showMap = StateProvider<bool>((ref) {
  return true;
});

class SelectCityView extends ConsumerWidget {
  const SelectCityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(createCommercialProfileProvider);
    var notifier = ref.read(createCommercialProfileProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione sua cidade'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: viewmodel.listOfTextControllers['searchCityInput'],
                decoration: InputDecoration(
                  labelText: 'Pesquisar cidade',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      try {
                        var a = await ref
                            .watch(locationRepositoryProvider)
                            .getAdressByInput(
                              viewmodel
                                  .listOfTextControllers['searchCityInput']!
                                  .text,
                            );
                        if (a != null) {
                          notifier.setLocalization(a);
                          notifier.setControllersText();
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
              if (viewmodel.selectedLocalization != null)
                Stack(
                  children: [
                    if (ref.watch(_showMap))
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            print('onMapCreatedView');
                            notifier.onMapCreated(controller);
                          },
                          onTap: (argument) async {
                            var local = await ref
                                .watch(locationRepositoryProvider)
                                .getAddress(argument);
                            print(local.lat);
                            print(local.lng);
                            print(local.numberName);
                            ref
                                .read(_localizationStateProvider.notifier)
                                .state = local;
                          },
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-20.8153677, -49.382611),
                            zoom: 12,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        ref.read(_showMap.notifier).state =
                            !ref.watch(_showMap);
                      },
                      icon: const Icon(Icons.map),
                    ),
                  ],
                ),
              if (ref.watch(_localizationStateProvider) != null)
                Text(ref.watch(_localizationStateProvider)!.fullAddress),
              TextFormField(
                controller:
                    viewmodel.listOfTextControllers['addressNameController'],
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              TextFormField(
                controller:
                    viewmodel.listOfTextControllers['cityNameController'],
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextFormField(
                controller: viewmodel
                    .listOfTextControllers['federativeUnitNameController'],
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewmodel
                          .listOfTextControllers['addressNumberController'],
                      decoration: InputDecoration(labelText: 'Número'),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: viewmodel
                          .listOfTextControllers['postalCodeController'],
                      decoration: InputDecoration(labelText: 'CEP'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: viewmodel
                    .listOfTextControllers['federativeUnitNameController'],
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: viewmodel
                    .listOfTextControllers['fullAddressNameController'],
                decoration: InputDecoration(labelText: 'Endereço completo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
