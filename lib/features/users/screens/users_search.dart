import 'package:effort/features/users/controllers/users_search_controller.dart';
import 'package:effort/features/users/screens/profile_card.dart';
import 'package:effort/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/list/effort_list.dart';
import '../../../utils/constants/colors.dart';

class UsersSearchScreen extends StatelessWidget {
  const UsersSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UserSearchController());

    return Scaffold(
      appBar: EffortAppBar(
        showBackArrow: false,
        title:  Text('Buscar Usuarios', style: Theme.of(context).textTheme.headlineMedium!.apply(color: EffortColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EffortSizes.defaultSpace),
        child: Column(
          children: [
            // Search Bar
            EffortSearchContainer(
              text: 'Search User',
              icon: Iconsax.search_normal,
              onTextChanged: (searchString) {
                controller.getUserBySearchWord(searchString);
              },
            ),

            const SizedBox(height: EffortSizes.spaceBtwSections),
            EffortList(
              searchList: controller.searchResultsObs,
              reloadFunction: controller.reloadUsers,
              customListViewBuilder: (context, list) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final item = list[index];
                    return ListTile(
                      title: Text(item.username,
                          style: const TextStyle(
                              fontSize: EffortSizes.fontSizeSm)),
                      trailing: SizedBox(
                        width: 80,
                        height: 30,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => ProfileCardScreen(user: item));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Ver Perfil',
                                style: TextStyle(
                                    fontSize: EffortSizes.fontSizeSm))),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}