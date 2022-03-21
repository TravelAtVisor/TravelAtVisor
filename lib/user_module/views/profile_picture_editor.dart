import 'dart:io';

import 'package:flutter/material.dart';
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
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/images.jpeg?alt=media&token=c61daa6c-ea9f-4361-8074-768fc2961283";

  String? _profilePicturePath;
  late bool _isRemotePhoto;

  @override
  void initState() {
    _isRemotePhoto = widget.initialProfilePicture == null;
    super.initState();
  }

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
                        _isRemotePhoto = true;
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
      _isRemotePhoto = false;
    });
  }

  Image getImage() {
    if (_isRemotePhoto == true || _profilePicturePath == null) {
      return Image.network(
          widget.initialProfilePicture ?? _defaultProfilePicture);
    }
    return Image.file(File(_profilePicturePath!));
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
