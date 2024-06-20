import 'package:effort/features/gym/models/statistic.dart';
import 'package:get/get.dart';

import '../../../utils/http/http_client.dart';



class StatisticsRepository extends GetxController {

  static StatisticsRepository get instance => Get.find();

  Future<Statistic> addStatistic(Statistic statistic, String username, String jwt) async {
    try {
      const endpoint = 'api/statistics';
      //final jsonToSend = statistic.toJson()['username'] = username;
      final jsonToSend = {
        'username': username,
        'day': statistic.day.toIso8601String().substring(0, 10),
        'time': statistic.time
      };

      final response = await EffortHttpHelper.post(endpoint, jsonToSend, jwt);
      return Statistic.fromJson(response);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<Statistic>> getStatistics(String username, String jwt) async {
    try {
      final endpoint = 'api/statistics/$username';
      var response = await EffortHttpHelper.get(endpoint, jwt);

      List<Statistic> statistics = <Statistic>[];
      for (var statistic in response['statistics']) {
        statistics.add(Statistic.fromJson(statistic));
      }

      return statistics;

    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}