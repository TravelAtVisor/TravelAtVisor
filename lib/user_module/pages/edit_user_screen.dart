import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/custom_user_data.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';
import 'package:travel_atvisor/user_module/views/edit_profile_form.dart';

import '../../shared_module/models/authentication_state.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  CustomUserData? customUserData;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, state, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Profil'),
          actions: [
            IconButton(
                onPressed: customUserData == null
                    ? null
                    : () async {
                        LoadingOverlay.show(context);
                        await context
                            .read<UserDataService>()
                            .updateUserProfileAsync(customUserData!);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                icon: Icon(
                  Icons.check,
                  color: customUserData == null
                      ? Colors.white.withOpacity(0.4)
                      : Colors.white,
                ))
          ],
        ),
        body: EditProfileForm(
          currentProfile: state.currentUser!.customData!,
          onProfileChanged: (newUserData) => setState(
            () => customUserData = newUserData,
          ),
        ),
      );
    });
  }
}
