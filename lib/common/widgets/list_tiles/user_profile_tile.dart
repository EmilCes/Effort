import 'package:effort/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../images/effort_circular_image.dart';

class EffortUserProfileTile extends StatelessWidget {
  const EffortUserProfileTile({
    super.key,
    required this.profilePicture,
    required this.fullName,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.streak,
    this.otherProfile = false,
    required this.onPressed,
  });

  final String profilePicture;
  final String fullName;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final int streak;
  final bool? otherProfile;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = EffortHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EffortSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EffortCircularImage(
                image: profilePicture,
                width: 120,
                height: 120,
                padding: 0,
              ),
              const SizedBox(width: EffortSizes.spaceBtwSections),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      followers.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: dark ? EffortColors.white : EffortColors.black),
                    ),
                    Text(
                      'Followers',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: dark ? EffortColors.white : EffortColors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      following.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: dark ? EffortColors.white : EffortColors.black),
                    ),
                    Text(
                      'Following',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: dark ? EffortColors.white : EffortColors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      streak.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color:dark ? EffortColors.white : EffortColors.black),
                    ),
                    Text(
                      'Racha',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: dark ? EffortColors.white : EffortColors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: EffortSizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: dark ? EffortColors.white : EffortColors.black),
              ),
              Text(
                '@$username',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: dark ? EffortColors.white : EffortColors.black),
              ),
            ],
          ),
          const SizedBox(height: EffortSizes.sm),
          Text(bio),
          const SizedBox(height: EffortSizes.sm),

          if (otherProfile == true)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => {},
                  child: const Text(EffortTexts.follow),
                ),
              ),
            ),

          const SizedBox(height: EffortSizes.sm),
          const Divider(),
        ],
      ),
    );
  }
}
