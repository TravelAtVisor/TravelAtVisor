import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';

import '../models/authentication_state.dart';

class AuthenticationGuard extends StatelessWidget {
  final WidgetBuilder loginBuilder;
  final WidgetBuilder userSafeBuilder;

  const AuthenticationGuard(
      {Key? key, required this.loginBuilder, required this.userSafeBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, authState, _) {
      if (!authState.isInitialized) {
        return const LoadingOverlay();
      }
      if (authState.hasCompleteProfile) {
        return userSafeBuilder(context);
      }
      return loginBuilder(context);
    });
  }
}
