import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/custom_text_input.dart';
import 'package:travel_atvisor/full_width_button.dart';
import 'package:travel_atvisor/loading_overlay.dart';

import '../../bottom_sheet_action.dart';
import '../behaviour/user_data_provider.dart';
import '../models/custom_user_data.dart';

class CompleteProfileStep extends StatefulWidget {
  final fullNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final biographyController = TextEditingController();
  final imagePicker = ImagePicker();

  CompleteProfileStep({Key? key}) : super(key: key);

  @override
  _CompleteProfileStepState createState() => _CompleteProfileStepState();
}

class _CompleteProfileStepState extends State<CompleteProfileStep> {
  bool _isUserNameValid = false;
  bool _isUserNameValidationFinished = false;
  bool _isFullNameValid = false;
  String? _profilePicturePath;

  bool _isFormValid() =>
      _isUserNameValidationFinished && _isUserNameValid && _isFullNameValid;

  Future<void> _validateUserName(
    String username,
    UserDataProvider UserDataProvider,
  ) async {
    setState(() {
      _isUserNameValidationFinished = false;
    });

    _isUserNameValid = username.contains(RegExp(r"\w")) &&
        await UserDataProvider.isUsernameAvailable(username);

    setState(() {
      _isUserNameValidationFinished = true;
    });
  }

  void _validateFullName(String fullName) {
    setState(() {
      _isFullNameValid = widget.fullNameController.text.contains(RegExp(r"\w"));
    });
  }

  void triggerPofilePictureWorkflow() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
              child: Wrap(
                children: [
                  BottomSheetAction(
                      icon: Icons.camera_alt,
                      label: "Profilbild aufnehmen",
                      onPressed: () async {
                        final pickedFile = await widget.imagePicker
                            .getImage(source: ImageSource.camera);
                        cropImage(pickedFile?.path);
                      }),
                  BottomSheetAction(
                      icon: Icons.browse_gallery,
                      label: "Profilbild auswählen",
                      onPressed: () async {
                        final pickedFile = await widget.imagePicker
                            .getImage(source: ImageSource.gallery);
                        cropImage(pickedFile?.path);
                      }),
                  BottomSheetAction(
                    icon: Icons.delete_forever,
                    label: "Profilbild entfernen",
                    onPressed: () => setState(() {
                      _profilePicturePath = null;
                    }),
                  )
                ],
              ),
            ));
  }

  Future<void> cropImage(String? filePath) async {
    if (filePath == null) return;

    final croppedFile = await ImageCropper.cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Profilbild zuschneiden',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      iosUiSettings: const IOSUiSettings(
          aspectRatioLockEnabled: true, title: "Profilbild zuschneiden"),
    );

    setState(() {
      _profilePicturePath = croppedFile?.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.read<UserDataProvider>().signOut();
              },
              icon: const Icon(Icons.chevron_left),
            ),
            const Text("Bitte erzähl uns noch etwas über dich"),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: triggerPofilePictureWorkflow,
                child: SizedBox(
                  height: 59,
                  width: 59,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: _profilePicturePath != null
                        ? Image.file(File(_profilePicturePath!))
                        : Image.network(
                            "https://lwkstuttgart.de/images/no-user-image.jpg"),
                  ),
                ),
              ),
            ),
            Flexible(
              child: CustomTextInput(
                controller: widget.fullNameController,
                labelText: "Voller Name",
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                onChanged: (fullName) => _validateFullName(fullName),
              ),
            )
          ],
        ),
        CustomTextInput(
          controller: widget.nicknameController,
          labelText: "Benutzername",
          autofillHints: const [AutofillHints.newUsername],
          autocorrect: false,
          textInputAction: TextInputAction.next,
          onChanged: (username) =>
              _validateUserName(username, context.read<UserDataProvider>()),
        ),
        CustomTextInput(
          controller: widget.biographyController,
          labelText: "Biographie",
          maxLines: 5,
          textInputAction: TextInputAction.done,
        ),
        FullWidthButton(
            text: "Abschließen",
            onPressed: _isFormValid()
                ? () async {
                    LoadingOverlay.show(context);
                    final customUserData = CustomUserData(
                        widget.nicknameController.text,
                        widget.fullNameController.text,
                        _profilePicturePath,
                        widget.biographyController.text);
                    await context
                        .read<UserDataProvider>()
                        .updateUserProfile(customUserData);
                    Navigator.pop(context);
                  }
                : null,
            isElevated: true)
      ],
    );
  }
}
