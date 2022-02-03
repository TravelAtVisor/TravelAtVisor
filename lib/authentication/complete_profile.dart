import 'package:flutter/widgets.dart';
import 'package:travel_atvisor/custom_text_input.dart';
import 'package:travel_atvisor/full_width_button.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

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
                  controller: TextEditingController(),
                  labelText: "Voller Name"),
            )
          ],
        ),
        CustomTextInput(
            controller: TextEditingController(), labelText: "Benutzername"),
        CustomTextInput(
          controller: TextEditingController(),
          labelText: "Biographie",
          maxLines: 5,
        ),
        FullWidthButton(text: "Abschließen", onPressed: () {}, isElevated: true)
      ],
    );
  }
}
