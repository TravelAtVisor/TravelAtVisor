import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/persistence/cloudfunction_dataservice.dart';
import 'package:travel_atvisor/trip_module/trip_dataservice.dart';

import 'home.dart';
import 'shared_module/user_data_provider.dart';
import 'user_data/components/authentication_guard.dart';
import 'user_module/pages/login_page.dart';
import 'user_data/models/authentication_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TravelAtVisorApp());
}

class TravelAtVisorApp extends StatelessWidget {
  const TravelAtVisorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudFunctionDataService = CloudFunctionDataService(
      FirebaseFunctions.instanceFor(region: "europe-west6"),
      FirebaseStorage.instance,
    );
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => cloudFunctionDataService,
        ),
        Provider<TripDataservice>(
          create: (_) => cloudFunctionDataService,
        ),
        Provider<UserDataProvider>(
          create: (context) {
            final authenticationDataService =
                context.read<CloudFunctionDataService>();
            return UserDataProvider(
                FirebaseAuth.instance, authenticationDataService);
          },
        ),
        StreamProvider(
            create: (context) => context.read<UserDataProvider>().authState,
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
