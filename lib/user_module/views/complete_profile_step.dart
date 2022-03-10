import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';
import 'package:travel_atvisor/user_module/views/edit_profile_form.dart';

import '../../shared_module/models/custom_user_data.dart';

class CompleteProfileStep extends StatefulWidget {
  const CompleteProfileStep({
    Key? key,
  }) : super(key: key);

  @override
  _CompleteProfileStepState createState() => _CompleteProfileStepState();
}

class _CompleteProfileStepState extends State<CompleteProfileStep> {
  CustomUserData? customUserData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.read<UserDataService>().signOutAsync();
              },
              icon: const Icon(Icons.chevron_left),
            ),
            const Text("Bitte erzähl uns noch etwas über dich"),
          ],
        ),
        EditProfileForm(
          onProfileChanged: (profile) {},
        ),
        FullWidthButton(
            text: "Abschließen",
            onPressed: customUserData != null
                ? () async {
                    LoadingOverlay.show(context);
                    await context
                        .read<UserDataService>()
                        .updateUserProfileAsync(customUserData!);
                    Navigator.pop(context);
                  }
                : null,
            isElevated: true)
      ],
    );
  }
}
