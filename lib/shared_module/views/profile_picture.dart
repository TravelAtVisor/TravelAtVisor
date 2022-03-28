import 'package:flutter/material.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

class ProfilePicture extends StatefulWidget {
  final UserSuggestion friend;
  final void Function(String userId) onRemoval;

  const ProfilePicture({
    Key? key,
    required this.friend,
    required this.onRemoval,
  }) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool isRemovalMode = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onLongPress: () => setState(() {
            isRemovalMode = true;
          }),
          onTap: () => setState(() {
            isRemovalMode = false;
          }),
          child: ClipOval(
            child: SizedBox(
              height: 64,
              width: 64,
              child: Image(
                image: NetworkImage(widget.friend.photoUrl),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: AnimatedOpacity(
            opacity: isRemovalMode ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(),
                ],
              ),
              child: IconButton(
                onPressed: isRemovalMode
                    ? () => widget.onRemoval(widget.friend.userId)
                    : null,
                icon: const Icon(Icons.remove),
                iconSize: 10,
                splashRadius: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
