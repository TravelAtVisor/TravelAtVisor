import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared_module/views/bottom_sheet_action.dart';

class ProfilePictureEditor extends StatefulWidget {
  final String? initialProfilePicture;
  final Function(String? newPath) onPictureChanged;

  final imagePicker = ImagePicker();

  ProfilePictureEditor({
    Key? key,
    this.initialProfilePicture,
    required this.onPictureChanged,
  }) : super(key: key);

  @override
  State<ProfilePictureEditor> createState() => _ProfilePictureEditorState();
}

class _ProfilePictureEditorState extends State<ProfilePictureEditor> {
  static const String _defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/ph_profile.png?alt=media&token=9273044a-565d-4699-9290-8910d30d9c43";

  String? _profilePicturePath;
  bool isDirty = false;

  void triggerPofilePictureWorkflow() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    BottomSheetAction(
                        icon: Icons.camera_alt,
                        label: "Profilbild aufnehmen",
                        onPressed: () async {
                          final pickedFile = await widget.imagePicker.getImage(
                              source: ImageSource.camera, imageQuality: 25);
                          cropImage(pickedFile?.path);
                        }),
                    BottomSheetAction(
                        icon: FontAwesomeIcons.image,
                        label: "Profilbild auswählen",
                        onPressed: () async {
                          final pickedFile = await widget.imagePicker.getImage(
                              source: ImageSource.gallery, imageQuality: 25);
                          cropImage(pickedFile?.path);
                        }),
                    if (_profilePicturePath != null ||
                        (widget.initialProfilePicture != null && !isDirty))
                      BottomSheetAction(
                        icon: Icons.delete_forever,
                        label: "Profilbild entfernen",
                        onPressed: () => setState(() {
                          _profilePicturePath = null;
                          isDirty = true;
                        }),
                      )
                  ],
                ),
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
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Profilbild zuschneiden',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      iosUiSettings: const IOSUiSettings(
          aspectRatioLockEnabled: true, title: "Profilbild zuschneiden"),
    );

    setState(() {
      _profilePicturePath = croppedFile?.path;
      isDirty = true;
    });
  }

  Image getImage() {
    if (!isDirty && widget.initialProfilePicture != null) {
      return Image.network(widget.initialProfilePicture!);
    }
    if (_profilePicturePath != null) {
      return Image.file(File(_profilePicturePath!));
    }
    return Image.network(_defaultProfilePicture);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.onPictureChanged(_profilePicturePath);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: triggerPofilePictureWorkflow,
        child: SizedBox(
          height: 59,
          width: 59,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: getImage(),
          ),
        ),
      ),
    );
  }
}
