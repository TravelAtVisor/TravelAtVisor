import 'package:flutter/material.dart';

abstract class TripNavigationService{
  Future<void> pushAddActivityScreen(BuildContext context, String tripID);
}