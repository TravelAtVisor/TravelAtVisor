import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/authentication_provider.dart';
import 'package:travel_atvisor/authentication/custom_user_data.dart';
import 'package:travel_atvisor/custom_text_input.dart';
import 'package:travel_atvisor/full_width_button.dart';

import '../bottom_sheet_action.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  _CompleteProfileViewState createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _biographyController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? profilePicturePath;

  void updateProfilePicture() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
              child: Wrap(
                children: [
                  BottomSheetAction(
                      icon: Icons.camera_alt,
                      label: "Profilbild aufnehmen",
                      onPressed: () async {
                        final pickedFile = await _imagePicker.getImage(
                            source: ImageSource.camera);
                        cropImage(pickedFile?.path);
                      }),
                  BottomSheetAction(
                      icon: Icons.browse_gallery,
                      label: "Profilbild auswählen",
                      onPressed: () async {
                        final pickedFile = await _imagePicker.getImage(
                            source: ImageSource.gallery);
                        cropImage(pickedFile?.path);
                      }),
                  BottomSheetAction(
                    icon: Icons.delete_forever,
                    label: "Profilbild entfernen",
                    onPressed: () => setState(() {
                      profilePicturePath = null;
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
      profilePicturePath = croppedFile?.path;
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
                context.read<AuthenticationProvider>().signOut();
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
                onTap: updateProfilePicture,
                child: SizedBox(
                  height: 59,
                  width: 59,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: profilePicturePath != null
                        ? Image.file(File(profilePicturePath!))
                        : Image.network(
                            "https://lwkstuttgart.de/images/no-user-image.jpg"),
                  ),
                ),
              ),
            ),
            Flexible(
              child: CustomTextInput(
                controller: _fullNameController,
                labelText: "Voller Name",
                textInputAction: TextInputAction.next,
              ),
            )
          ],
        ),
        CustomTextInput(
          controller: _nicknameController,
          labelText: "Benutzername",
          textInputAction: TextInputAction.next,
        ),
        CustomTextInput(
          controller: _biographyController,
          labelText: "Biographie",
          maxLines: 5,
          textInputAction: TextInputAction.done,
        ),
        FullWidthButton(
            text: "Abschließen",
            onPressed: () {
              final customUserData = CustomUserData(
                  _nicknameController.text,
                  _fullNameController.text,
                  profilePicturePath,
                  _biographyController.text);
              context
                  .read<AuthenticationProvider>()
                  .updateUserProfile(customUserData);
            },
            isElevated: true)
      ],
    );
  }
}
