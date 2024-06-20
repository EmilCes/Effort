import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AddExerciseDialog extends StatelessWidget {
  final TextEditingController seriesController;
  final TextEditingController repetitionsController;
  final VoidCallback onConfirm;

  AddExerciseDialog({
    super.key,
    required this.seriesController,
    required this.repetitionsController,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: seriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Series'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingrese el número de series';
              }
              return null;
            },
          ),
          const SizedBox(height: EffortSizes.spaceBtwInputFields),
          TextFormField(
            controller: repetitionsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Repeticiones'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingrese el número de repeticiones';
              }
              return null;
            },
          ),
          const SizedBox(height: EffortSizes.spaceBtwItems),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
