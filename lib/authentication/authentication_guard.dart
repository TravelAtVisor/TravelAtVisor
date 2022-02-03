import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AuthenticationGuard extends StatelessWidget {
  final WidgetBuilder loginBuilder;
  final WidgetBuilder userSafeBuilder;

  const AuthenticationGuard(
      {Key? key, required this.loginBuilder, required this.userSafeBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return userSafeBuilder(context);
    }
    return loginBuilder(context);
  }
}
