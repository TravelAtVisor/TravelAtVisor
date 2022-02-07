import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/authentication/authentication_provider.dart';
import 'package:travel_atvisor/authentication/authentication_state.dart';
import 'package:travel_atvisor/firebase_options.dart';
import 'package:travel_atvisor/persistence/firebase_dataservice.dart';

import 'authentication/authentication_guard.dart';
import 'home_page.dart';
import 'authentication/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseDataservice>(
            create: (_) => FirebaseDataservice(FirebaseFirestore.instance)),
        Provider<AuthenticationProvider>(
          create: (context) {
            final authenticationDataService =
                context.read<FirebaseDataservice>();
            return AuthenticationProvider(
                FirebaseAuth.instance, authenticationDataService);
          },
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationProvider>().authState,
            initialData: AuthenticationState.initialState),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthenticationGuard(
          loginBuilder: (_) => Consumer<AuthenticationState>(
            builder: (context, value, child) => LoginPage(
              authenticationState: value,
            ),
          ),
          userSafeBuilder: (_) => const HomePage(),
        ),
      ),
    );
  }
}
