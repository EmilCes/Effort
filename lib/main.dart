import 'package:effort/app.dart';
import 'package:effort/data/repositories/authentication/authentication_repository.dart';
import 'package:effort/data/repositories/gym/daily_routine_repository.dart';
import 'package:effort/data/repositories/gym/exercise_repository.dart';
import 'package:effort/data/repositories/gym/statistics_repository.dart';
import 'package:effort/data/repositories/gym/weekly_routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {

  // Load .env
  await dotenv.load(fileName: ".env");

  // Widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  await GetStorage.init();

  // Await Native Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(AuthenticationRepository());
  Get.put(ExerciseRepository());
  Get.put(DailyRoutineRepository());
  Get.put(WeeklyRoutineRepository());
  Get.put(StatisticsRepository());

  // Load al the Material Design / Themes / Localizations / Bindings
  runApp(const App());
}


