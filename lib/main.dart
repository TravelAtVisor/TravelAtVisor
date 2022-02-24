import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:travel_atvisor/shared_module/data_service.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/views/authentication_guard.dart';
import 'package:travel_atvisor/trip_module/trip_dataservice.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

import 'home.dart';
import 'shared_module/user_data_provider.dart';
import 'user_module/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TravelAtVisorApp());
}

class TravelAtVisorApp extends StatelessWidget {
  const TravelAtVisorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudFunctionDataService = DataService(
      FirebaseFunctions.instanceFor(region: "europe-west6"),
      FirebaseStorage.instance,
    );
    return MultiProvider(
      providers: [
        Provider<TripDataservice>(
          create: (_) => cloudFunctionDataService,
        ),
        Provider<UserDataService>(
          create: (_) => cloudFunctionDataService,
        ),
        Provider<ActivityDataService>(
          create: (_) => cloudFunctionDataService,
        ),
        Provider<AuthenticationProvider>(
          create: (context) {
            final authenticationDataService = cloudFunctionDataService;
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
          userSafeBuilder: (_) => Home(),
        ),
      ),
    );
  }
}
