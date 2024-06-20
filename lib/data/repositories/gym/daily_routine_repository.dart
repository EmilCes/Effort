import 'package:effort/features/gym/models/daily_routine.dart';
import 'package:get/get.dart';

import '../../../utils/http/http_client.dart';



class DailyRoutineRepository extends GetxController {

  static DailyRoutineRepository get instance => Get.find();

  Future<DailyRoutine> getDailyRoutineById(int routineId, String jwt) async {
    try {
      final endpoint = 'api/dailyroutines/$routineId';
      var response = await EffortHttpHelper.get(endpoint, jwt);


      return DailyRoutine.fromJson(response);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<DailyRoutine>> getDailyRoutines(String username, String jwt) async {
    try {
      final endpoint = 'api/users/$username/dailyroutines';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      List<DailyRoutine> dailyRoutines = <DailyRoutine>[];

      if (response.isNotEmpty) {
        for (var dailyRoutine in response['routines']) {
          dailyRoutines.add(DailyRoutine.fromJson(dailyRoutine));
        }
      }

      return dailyRoutines;

    } catch (e) {
        throw 'Something went wrong. Please try again.';
    }

  }

  Future<DailyRoutine> registerDailyRoutine(DailyRoutine dailyRoutine, String jwt) async {
    try {
      const endpoint = 'api/dailyroutines';
      final response = await EffortHttpHelper.post(endpoint, dailyRoutine.toJson(), jwt);
      return DailyRoutine.fromJson(response);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateDailyRoutine(DailyRoutine dailyRoutine, String jwt) async {
    try {
      final endpoint = 'api/dailyroutines/${dailyRoutine.routineId}';
      await EffortHttpHelper.put(endpoint, dailyRoutine.toJson(), jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> registerDailyRoutineExercises(int routineId, List<Map<String, dynamic>> exercises, String jwt) async {
    try {
      final endpoint = 'api/dailyroutines/$routineId/exercises';

      Map<String, dynamic> data = {
        'exercises': exercises
      };

      await EffortHttpHelper.post(endpoint, data, jwt);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void>updateDailyRoutineExercises(int routineId, List<Map<String, dynamic>> exercises, String jwt) async {
    try {
      final endpoint = 'api/dailyroutines/$routineId/exercises';

      Map<String, dynamic> data = {
        'exercises': exercises
      };

      await EffortHttpHelper.put(endpoint, data, jwt);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> registerDailyRoutineUsers(int routineId, String username, bool isOwner, String jwt) async {
    try {
      final endpoint = 'api/users/$username/dailyroutines/$routineId';

      Map<String, dynamic> data = {
        'isOwner': isOwner
      };

      await EffortHttpHelper.post(endpoint, data, jwt);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}