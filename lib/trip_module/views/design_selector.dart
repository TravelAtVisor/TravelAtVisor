import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DesignSelector extends StatefulWidget {
  final String? initialPath;
  final void Function(String designPath) onPathChanged;

  static const defaultDesigns = [
    "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/trip_designs%2Falpen.png?alt=media&token=cce69cb7-14fe-4407-9308-b2c64385ce4c",
    "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/trip_designs%2Froadtrip.png?alt=media&token=880d0ea6-c928-43d6-8223-4c301a4df019",
    "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/trip_designs%2Fskyline.png?alt=media&token=864618d6-3be3-4c57-979d-aa49348aee48",
    "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/trip_designs%2Fstrand.png?alt=media&token=1e7a1e2b-03cd-49f0-aced-76eb99043588",
  ];

  const DesignSelector({
    Key? key,
    required this.onPathChanged,
    this.initialPath,
  }) : super(key: key);

  @override
  State<DesignSelector> createState() => _DesignSelectorState();
}

class _DesignSelectorState extends State<DesignSelector> {
  final imagePicker = ImagePicker();
  int currentDesign = -1;
  String? customImagePath;

  @override
  void initState() {
    if (widget.initialPath != null) {
      final indexFound = DesignSelector.defaultDesigns
          .indexWhere((element) => widget.initialPath == element);
      currentDesign =
          indexFound >= 0 ? indexFound : DesignSelector.defaultDesigns.length;
      customImagePath = widget.initialPath;
    }
    super.initState();
  }

  DecorationImage? getDecorationImage(int index) {
    if (index == DesignSelector.defaultDesigns.length) {
      if (customImagePath == null) return null;

      final imageFile = File(customImagePath!);
      return DecorationImage(
        image: imageFile.existsSync()
            ? FileImage(
                File(customImagePath!),
              ) as ImageProvider
            : NetworkImage(customImagePath!),
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
      );
    }
    return DecorationImage(
      image: NetworkImage(
        DesignSelector.defaultDesigns.elementAt(index),
      ),
      fit: BoxFit.fitWidth,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Design wählen"),
        GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              final elevation = currentDesign == index ? 10.0 : 1.0;

              return AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: currentDesign == index ? 1 : 0.88,
                child: GestureDetector(
                    onTap: () async {
                      if (index == DesignSelector.defaultDesigns.length) {
                        if (customImagePath == null) {
                          await pickCustomImage();
                        }
                        setState(() {
                          currentDesign = index;
                        });
                        return;
                      }
                      setState(() {
                        currentDesign = index;
                      });
                      widget.onPathChanged(DesignSelector.defaultDesigns
                          .elementAt(currentDesign));
                    },
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          elevation: elevation,
                          child: Container(
                            decoration: BoxDecoration(
                              image: getDecorationImage(index),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Center(
                                  child: index ==
                                          DesignSelector.defaultDesigns.length
                                      ? IconButton(
                                          onPressed: () => pickCustomImage(),
                                          icon: const Icon(Icons.edit),
                                        )
                                      : const Text(
                                          "Reisetitel",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30.0),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              );
            }),
      ],
    );
  }

  Future<void> pickCustomImage() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      customImagePath = image.path;
      currentDesign = DesignSelector.defaultDesigns.length;
    });
    widget.onPathChanged(image.path);
  }
}
