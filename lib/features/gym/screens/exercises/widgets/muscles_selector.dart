import 'package:effort/utils/constants/colors.dart';
import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:muscle_selector/muscle_selector.dart';
import 'package:flutter/material.dart';

class MuscleSelectorWidget extends StatefulWidget {
  final void Function(Set<Muscle>?) onChanged;
  final List<String>? initializeMusclesGroups;
  final bool isEditMode;

  const MuscleSelectorWidget({
    Key? key,
    required this.onChanged,
    this.initializeMusclesGroups,
    this.isEditMode = false
  }) : super(key: key);

  @override
  _MuscleSelectorWidgetState createState() => _MuscleSelectorWidgetState();
}

class _MuscleSelectorWidgetState extends State<MuscleSelectorWidget> {
  Set<Muscle>? selectedMuscles;
  final GlobalKey<MusclePickerMapState> _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final dark = EffortHelperFunctions.isDarkMode(context);

    return InteractiveViewer(
      scaleEnabled: true,
      panEnabled: true,
      constrained: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 30.0), // Add right margin
        child: Align(
          alignment: Alignment.center,
          child: Transform.scale(
            scale: 1,
            child: MusclePickerMap(
              key: _mapKey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              map: Maps.BODY,
              onChanged: (muscles) {
                setState(() {
                  selectedMuscles = muscles;
                });
                widget.onChanged(selectedMuscles);
              },
              actAsToggle: true,
              dotColor: EffortColors.darkBackground,
              selectedColor: EffortColors.primary,
              strokeColor: dark ? Colors.white24 : Colors.black26,
              isEditing: widget.isEditMode,
              initialSelectedGroups: widget.initializeMusclesGroups,
            ),
          ),
        ),
      ),
    );
  }
}
