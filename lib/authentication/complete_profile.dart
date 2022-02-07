import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:travel_atvisor/authentication/authentication_provider.dart';
import 'package:travel_atvisor/authentication/custom_user_data.dart';
import 'package:travel_atvisor/custom_text_input.dart';
import 'package:travel_atvisor/full_width_button.dart';

class CompleteProfileView extends StatelessWidget {
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _biographyController = TextEditingController();

  CompleteProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 32.0),
          child: Text("Bitte erzähl uns noch etwas über dich"),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 59,
                width: 59,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                      "https://lwkstuttgart.de/images/no-user-image.jpg"),
                ),
              ),
            ),
            Flexible(
              child: CustomTextInput(
                  controller: _fullNameController, labelText: "Voller Name"),
            )
          ],
        ),
        CustomTextInput(
            controller: _nicknameController, labelText: "Benutzername"),
        CustomTextInput(
          controller: _biographyController,
          labelText: "Biographie",
          maxLines: 5,
        ),
        FullWidthButton(
            text: "Abschließen",
            onPressed: () {
              final customUserData = CustomUserData(_nicknameController.text,
                  _fullNameController.text, null, _biographyController.text);
              context
                  .read<AuthenticationProvider>()
                  .updateUserProfile(customUserData);
            },
            isElevated: true)
      ],
    );
  }
}
