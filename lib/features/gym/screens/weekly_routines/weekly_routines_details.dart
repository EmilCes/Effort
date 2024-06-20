import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:effort/features/gym/screens/weekly_routines/widgets/weekly_daily_routine.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/appbar/popup_menu_button.dart';
import '../../../../utils/constants/colors.dart';
import '../../controllers/weekly_routines/weekly_routines_controller.dart';
import 'package:intl/intl.dart';

import '../../models/daily_routine.dart';

class WeeklyRoutineScreen extends StatelessWidget {
  final controller = Get.put(WeeklyRoutinesController());
  final bool isPlayMode;

  WeeklyRoutineScreen({super.key, this.isPlayMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: false,
        title: Text(
          isPlayMode == true ? "Today's Routine" : 'Weekly Routine',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white),
        ),
        actions: isPlayMode == false
        ? [
          Obx(() => EffortPopupMenuButton(
            iconData: controller.isEditMode.value ? Icons.cancel : Icons.edit,
            onSelected: (String result) {
              if (result == 'edit_weekly_routine') {
                controller.toggleEditMode();
              } else if (result == 'cancel') {
                controller.toggleEditMode();
              }
            },
            itemBuilder: (BuildContext context) => controller.isEditMode.value
                ? [
              const PopupMenuItem<String>(
                value: 'cancel',
                child: Text('Cancelar edición'),
              ),
            ]
                : [
              const PopupMenuItem<String>(
                value: 'edit_weekly_routine',
                child: Text('Editar rutina semanal'),
              ),
            ],
          )),
        ]
        : null
      ),
      body: Obx(() {
        var routines = controller.weeklyRoutine.value.routines ?? [];
        var today = DateFormat('EEEE').format(DateTime.now());

        if (isPlayMode) {
          var todayRoutine = routines.firstWhere(
                (routine) => routine.day == today,
            orElse: () => DailyRoutine(day: today, routineId: 0, name: ''),
          );
          routines = [todayRoutine];
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return Obx(() => WeeklyDailyRoutine(
              text: routine.day ?? '',
              bottomText: 'ejemplo',
              isEditMode: controller.isEditMode.value,
              routineId: routine.routineId?.toString() ?? '',
              routineName: routine.name,
              isPlayMode: isPlayMode,
              onTap: () {},
            ));
          },
        );
      }),
    );
  }
}