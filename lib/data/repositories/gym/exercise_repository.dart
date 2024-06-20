import 'package:effort/data/services/videos/video_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/gym/models/exercise.dart';
import '../../../features/gym/models/muscle.dart';
import '../../../utils/http/http_client.dart';



class ExerciseRepository extends GetxController {

  static ExerciseRepository get instance => Get.find();

  Future<Exercise> registerExercise(Exercise exercise, String jwt) async {
    try {
      const endpoint = 'api/exercises';
      final response = await EffortHttpHelper.post(endpoint, exercise.toJson(), jwt);
      return Exercise.fromJson(response);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateExercise(Exercise exercise, String jwt) async {
    try {
      final endpoint = 'api/exercises/${exercise.exerciseId}';
      await EffortHttpHelper.put(endpoint, exercise.toJson(), jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  
  Future<void> registerExerciseMuscles(int exerciseId, List<MuscleEffort> muscles, String jwt) async {
    try {
      final endpoint = 'api/exercises/$exerciseId/muscles';

      List<Map<String, dynamic>> musclesJson = muscles.map((muscle) => muscle.toJson()).toList();

      Map<String, dynamic> data = {
        'muscles': musclesJson
      };

      await EffortHttpHelper.post(endpoint, data, jwt);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateExerciseMuscles(int exerciseId, List<MuscleEffort> muscles, String jwt) async {
    try {
      final endpoint = 'api/exercises/$exerciseId/muscles';

      List<Map<String, dynamic>> musclesJson = muscles.map((muscle) => muscle.toJson()).toList();

      Map<String, dynamic> data = {
        'muscles': musclesJson
      };

      await EffortHttpHelper.put(endpoint, data, jwt);

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<Exercise>> getExercises(String jwt) async {
    try {
      const endpoint = 'api/exercises';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      List<Exercise> exercises = <Exercise>[];
      for (var exercise in response['exercises']) {
        exercises.add(Exercise.fromJson(exercise));
      }

      return exercises;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<Exercise>> getExercisesToValidate(String jwt) async {
    try {
      const endpoint = 'api/invalidExercises';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      List<Exercise> exercises = <Exercise>[];
      for (var exercise in response['exercises']) {
        exercises.add(Exercise.fromJson(exercise));
      }

      return exercises;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> validateExercise(int exerciseId, bool isValid, String jwt) async {
    try {
      final endpoint = 'api/invalidExercises/$exerciseId';

      final data = {
        "isValid": isValid
      };

      await EffortHttpHelper.put(endpoint, data, jwt);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  
  Future<void> uploadVideo(XFile video, String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt, videoUrl: videoUrl, videoFile: video);
    return videoService.startUpload();
  }

  Future<XFile> downloadVideo(String videoUrl, String jwt) async {
    VideoService videoService = VideoService(jwt: jwt);
    return videoService.startDownload(videoUrl);
  }
}