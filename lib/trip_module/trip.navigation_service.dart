import 'package:flutter/material.dart';

abstract class TripNavigationService{
  Future<void> pushAddActivityScreen(BuildContext context, String tripID);
  Future<void> pushActivityDetailScreen(BuildContext context, String foursquareId);
}