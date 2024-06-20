import 'package:effort/data/repositories/gym/statistics_repository.dart';
import 'package:effort/data/repositories/user/user_repository.dart';
import 'package:effort/features/authentication/models/user_credential.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/popups/loaders.dart';
import '../../authentication/models/user_model.dart';
import '../screens/profile/profile_details.dart';

class UserController extends GetxController {

  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final RxList<DateTime> days = <DateTime>[].obs;
  final RxList<double> times = <double>[].obs;

  Rx<UserModel> user = UserModel.empty().obs;
  UserCredential? userCredential;

  Future<void> fetchUserStatisticsData() async {
    try {
      final statistics = await StatisticsRepository.instance.getStatistics(userCredential!.username, userCredential!.jwt);

      for (var element in statistics) {
        days.add(element.day);
        times.add(element.time.toDouble());
      }

    } catch (e) {
      EffortLoaders.errorSnackBar(title: 'Snap!', message: 'There was an error..');
    }
  }

  Future<void> fetchUserData() async {
    try {
      await fetchUserStatisticsData();
      final user = await userRepository.fetchUserDetails(userCredential!.username, userCredential!.jwt);
      this.user(user);

      if (user.fileId != null) {
        fetchUserProfilePicture();
      }

    } catch (e) {
      user(UserModel.empty());
    }
  }
  
  Future<void> fetchUserProfilePicture() async {
    try {
      var response = await userRepository.getImage(user.value.fileId!, userCredential!.jwt);
      user.update((value) {
        value?.profilePicture = response.path;
      });
    } catch(e) {
      EffortLoaders.errorSnackBar(title: 'Snap!', message: 'There was an error..');
    }
  }

  uploadUserProfilePicture() async {
    XFile? image;

    if (GetPlatform.isMobile) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else if (GetPlatform.isDesktop) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        image = XFile(result.files.single.path!);
      }
    }

    if (image != null) {
      try {
        String fileName = '${userCredential!.username}ProfileImage.jpg';

        Map<String, dynamic> response;
        if (user.value.fileId == null) {
          response = await userRepository.uploadImage(image, fileName, userCredential!.jwt);
          int fileId = response['fileId'];

          await userRepository.addImageToUser(userCredential!.username, fileId, userCredential!.jwt);
          user.value.fileId = fileId;
        } else {
          await userRepository.updateImage(user.value.fileId!, image, fileName, userCredential!.jwt);
        }

        //user.value.profilePicture = image.path;
        user.value.profilePicture = image.path;

        update();

        Get.back();
        Get.to(() => const ProfileDetailsScreen());

        EffortLoaders.successSnackBar(title: 'Congruatulations', message: 'Your profile image has been updated.');

      } catch (e) {
        EffortLoaders.successSnackBar(title: 'Snap!', message: 'There was an error updating your profile..');

      }
    }
  }
}