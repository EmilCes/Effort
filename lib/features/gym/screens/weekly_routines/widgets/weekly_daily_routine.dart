import 'package:effort/features/gym/screens/daily_routines/daily_routines_search.dart';
import 'package:effort/features/gym/screens/weekly_routines/play_routine.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:effort/utils/constants/colors.dart';
import 'package:get/route_manager.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class WeeklyDailyRoutine extends StatelessWidget {

  final String text;
  final String bottomText;
  final String? routineId;
  final String? routineName;
  final bool isEditMode;
  final bool isPlayMode;
  final VoidCallback onTap;

  const WeeklyDailyRoutine({
    Key? key,
    required this.text,
    required this.bottomText,
    this.routineId,
    this.routineName,
    this.isPlayMode = false,
    required this.isEditMode,
    required this.onTap,
  }) : super(key: key);

  void _deleteRoutine(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Se elimina la rutina.'),
      ),
    );
  }

  void _showRoutineDetails(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Se muestran los detalles de la rutina.'),
      ),
    );
  }

  void _showPlayRoutine() {
    Get.to(() => PlayRoutineScreen(routineId: int.tryParse(routineId!)!));
  }

  @override
  Widget build(BuildContext context) {

    var credentials = UserController.instance.userCredential;
    final dark = EffortHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          Get.to(() => DailyRoutineSearchScreen(username: credentials!.username, weeklyRoutineMode: true, day: text));
        } else {
          onTap();
        }
      },
      child: Column(
        children: [
          Container( // Barra superior
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: dark ? EffortColors.darkerGrey : EffortColors.lightGrey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 0.0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isEditMode)
                  IconButton(
                    icon: Icon(routineId!.isNotEmpty ? Icons.delete : Icons.add),
                    color: routineId!.isNotEmpty ? Colors.red : Colors.green,
                    onPressed: () {
                      if (routineId!.isNotEmpty) {
                        _deleteRoutine(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Se muestra la lista de rutinas.'),
                          ),
                        );
                      }
                    },
                  )
                else
                  IconButton(
                    icon: isPlayMode ? const Icon(Icons.play_circle) : const Icon(Icons.question_mark),
                    color: Colors.green,
                    onPressed: () {
                      isPlayMode ? _showPlayRoutine() : _showRoutineDetails(context);
                    },
                  ),
              ],
            ),
          ),
          Container( // Barra inferior
            margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 17.0),
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: dark ? EffortColors.darkerGrey : EffortColors.lightGrey,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 0.0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Text(
                  routineName?.isNotEmpty == true
                      ? routineName!
                      : 'Descanso',
                  style: routineName?.isNotEmpty == true
                      ? dark ? const TextStyle(color: EffortColors.textWhite) : const TextStyle(color: EffortColors.textPrimary)
                      : dark ? const TextStyle(color: EffortColors.textWhite) : const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(width: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
