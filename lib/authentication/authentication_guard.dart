import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/authentication_state.dart';

class AuthenticationGuard extends StatelessWidget {
  final WidgetBuilder loginBuilder;
  final WidgetBuilder userSafeBuilder;

  const AuthenticationGuard(
      {Key? key, required this.loginBuilder, required this.userSafeBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(builder: (context, authState, _) {
      if (authState.hasCompleteProfile) {
        return userSafeBuilder(context);
      }
      return loginBuilder(context);
    });
  }
}
