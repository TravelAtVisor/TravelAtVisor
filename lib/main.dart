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
import 'package:travel_atvisor/trip_module/trip.data_service.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

import 'home.dart';
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
    final dataService = DataService(
      FirebaseFunctions.instanceFor(region: "europe-west6"),
      FirebaseStorage.instance,
      FirebaseAuth.instance,
    );
    return MultiProvider(
      providers: [
        Provider<TripDataservice>(
          create: (_) => dataService,
        ),
        Provider<UserDataService>(
          create: (_) => dataService,
        ),
        Provider<ActivityDataService>(
          create: (_) => dataService,
        ),
        StreamProvider(
            create: (_) => dataService.applicationState,
            initialData: ApplicationState.initialState),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade400,
          ),
        ),
        home: AuthenticationGuard(
          loginBuilder: (_) => Consumer<ApplicationState>(
            builder: (context, value, child) => LoginPage(
              authenticationState: value,
            ),
          ),
          userSafeBuilder: (_) => GlobalTabController(),
        ),
      ),
    );
  }
}
