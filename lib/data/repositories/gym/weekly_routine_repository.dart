import 'package:effort/utils/http/http_client.dart';
import 'package:get/get.dart';

import '../../../features/authentication/models/user_model.dart';
import '../../../features/gym/models/daily_routine.dart';
import '../../../features/gym/models/weekly_routine.dart';

class WeeklyRoutineRepository extends GetxController {

  static WeeklyRoutineRepository get instance => Get.find();

  Future<Map<String, dynamic>> fetchWeeklyRoutineDetails(String username) async {
    try {
      var endpoint = 'api/weeklyroutines/users/$username';
      var response = await EffortHttpHelper.get(endpoint, null);

      return response;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

    Future<Map<String, dynamic>> registerWeeklyRoutine(WeeklyRoutine weeklyRoutine, UserModel userModel, String jwt) async {
    try {
      var endpoint = 'api/weeklyroutines';

      var customJson = {
        'name': weeklyRoutine.name,
        'userId': userModel.userId, // Supongo que este valor se debe obtener de algún lugar
        'routines': convertRoutinesToJson(weeklyRoutine.routines),
      };

      var response = await EffortHttpHelper.post(endpoint, customJson, jwt);

      return response;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<Map<String, dynamic>> updateWeeklyRoutine(WeeklyRoutine weeklyRoutine, UserModel userModel, String jwt) async {
    try {
      String? weeklyRoutineId = weeklyRoutine.weeklyRoutineId;
      var endpoint = 'api/weeklyroutines/$weeklyRoutineId';

      var customJson = {
        'name': weeklyRoutine.name,
        'routines': convertRoutinesToJson(weeklyRoutine.routines),
      };


      var response = await EffortHttpHelper.put(endpoint, customJson, jwt);

      return response;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Map<String, dynamic> convertRoutinesToJson(List<DailyRoutine>? routines) {
    var jsonMap = <String, dynamic>{};
    if (routines != null) {
      for (var routine in routines) {
        jsonMap[routine.day!] = routine.routineId != 0 ? routine.routineId : null;
      }
    }
    return jsonMap;
  }
}