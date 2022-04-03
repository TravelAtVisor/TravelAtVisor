import 'package:flutter/material.dart';

abstract class GlobalNavigationService {
  void pushAddTripPage(BuildContext context);

  Future<void> pushAddActivityScreen(BuildContext context, String tripID);
}
