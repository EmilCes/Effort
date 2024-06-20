import 'package:flutter/material.dart';
import 'package:effort/features/gym/models/exercise.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/helpers/helper_functions.dart';

class ExerciseContainer extends StatelessWidget {
  final Exercise? exercise;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ExerciseContainer({
    Key? key,
    this.exercise,
    required this.isLast,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: exercise == null
              ? Colors.grey.withOpacity(0.5)
              : dark
              ? Colors.grey.withOpacity(0.5)
              : EffortColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise != null)
                    Text(
                      exercise!.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: dark
                            ? EffortColors.white
                            : EffortColors.black,
                      ),
                    )
                  else
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.add),
                    ),
                ],
              ),
            ),
            if (exercise != null) ...[
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Series: ${exercise!.dailyRoutineExercise!.series}',
                    style: TextStyle(
                      color: dark ? EffortColors.white : EffortColors.black,
                    ),
                  ),
                  Text(
                    'Repeticiones: ${exercise!.dailyRoutineExercise!.repetitions}',
                    style: TextStyle(
                      color: dark ? EffortColors.white : EffortColors.black,
                    ),
                  ),
                ],
              ),
            ],

            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.cancel, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

