import 'package:effort/data/repositories/user/user_repository.dart';
import 'package:effort/features/authentication/models/user_credential.dart';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';
import '../../../data/repositories/gym/statistics_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/models/user_model.dart';


class UserCardController extends GetxController {

  static UserCardController get instance => Get.find();

  final UserCredential credential = UserController.instance.userCredential!;
  final UserRepository userRepository = Get.put(UserRepository());
  final Rx<UserModel> user = UserModel.empty().obs;
  final RxList<DateTime> days = <DateTime>[].obs;
  final RxList<double> times = <double>[].obs;
  String username = '';

  Future<void> fetchUserStatisticsData() async {
    try {
      final statistics = await StatisticsRepository.instance.getStatistics(credential.username, credential.jwt);

      for (var element in statistics) {
        days.add(element.day);
        times.add(element.time.toDouble());
      }

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Snap!', message: 'There was an error..');
    }
  }

  Future<void> fetchUserData(String username) async {
    try {
      await fetchUserStatisticsData();
      final UserModel fetchedUser = await userRepository.fetchUserDetails(username, credential.jwt);
      user.update((value) {
        value!.name = fetchedUser.name;
        value.lastname = fetchedUser.lastname;
        value.fileId = fetchedUser.fileId;
        value.streak = fetchedUser.streak;
        value.userId = fetchedUser.userId;
        value.bio = fetchedUser.bio;
        value.username = fetchedUser.username;
      });

      if (fetchedUser.fileId != null) {
        await fetchUserProfilePicture();
      }

    } catch (e) {
      user(UserModel.empty());
    }
  }

  Future<void> fetchUserProfilePicture() async {
    try {
      var response = await userRepository.getImage(user.value.fileId!, credential.jwt);
      user.update((value) {
        value!.profilePicture = response.path;
      });
    } catch(e) {
      EffortLoaders.successSnackBar(title: 'Snap!', message: 'There was an error updating your profile..');
    }
  }

}
