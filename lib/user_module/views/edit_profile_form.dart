import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/utils/debouncer.dart';
import 'package:travel_atvisor/user_module/views/profile_picture_editor.dart';

import '../../shared_module/models/custom_user_data.dart';
import '../../shared_module/views/custom_text_input.dart';
import '../user.data_service.dart';

class EditProfileForm extends StatefulWidget {
  final CustomUserData? currentProfile;
  final Function(CustomUserData? currentProfile) onProfileChanged;
  final Debouncer debouncer = Debouncer(milliseconds: 150);

  EditProfileForm({
    Key? key,
    required this.onProfileChanged,
    this.currentProfile,
  }) : super(key: key);

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final TextEditingController fullNameController;
  late final TextEditingController nicknameController;
  late final TextEditingController biographyController;

  bool _isUserNameValid = false;
  bool _isUserNameValidationFinished = true;
  bool _isFullNameValid = false;
  String? _profilePicturePath;

  @override
  void initState() {
    fullNameController = TextEditingController(
      text: widget.currentProfile?.fullName,
    );
    nicknameController = TextEditingController(
      text: widget.currentProfile?.nickname,
    );
    biographyController = TextEditingController(
      text: widget.currentProfile?.biography,
    );

    _isFullNameValid = widget.currentProfile != null;
    _isUserNameValid = widget.currentProfile != null;
    _profilePicturePath = widget.currentProfile?.photoUrl;

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    emitProfileChanges();
  }

  void emitProfileChanges() {
    final isFormValid =
        _isFullNameValid && _isUserNameValidationFinished && _isUserNameValid;

    widget.onProfileChanged(isFormValid
        ? CustomUserData(
            nicknameController.text,
            fullNameController.text,
            _profilePicturePath,
            biographyController.text,
            widget.currentProfile?.trips ?? [],
            widget.currentProfile?.friends ?? [])
        : null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                ProfilePictureEditor(
                  onPictureChanged: (picture) => setState(() {
                    _profilePicturePath = picture;
                  }),
                  initialProfilePicture: widget.currentProfile?.photoUrl,
                ),
                Flexible(
                  child: CustomTextInput(
                    controller: fullNameController,
                    labelText: "Voller Name",
                    autofillHints: const [AutofillHints.name],
                    textInputAction: TextInputAction.next,
                    onChanged: (fullName) => setState(() {
                      _isFullNameValid = fullName.contains(RegExp(r"\w"));
                    }),
                  ),
                )
              ],
            ),
            CustomTextInput(
              controller: nicknameController,
              labelText: "Benutzername",
              autofillHints: const [AutofillHints.newUsername],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onChanged: (username) => widget.debouncer.run(() async {
                setState(() {
                  _isUserNameValidationFinished = false;
                });
                final isValid = await context
                    .read<UserDataService>()
                    .isUsernameAvailableAsync(username);
                setState(() {
                  _isUserNameValidationFinished = true;
                  _isUserNameValid = isValid;
                });
              }),
            ),
            CustomTextInput(
              controller: biographyController,
              labelText: "Biographie",
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onChanged: (_) => emitProfileChanges(),
            ),
          ],
        ),
      ),
    );
  }
}
