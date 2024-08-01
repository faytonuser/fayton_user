import 'package:flutter/material.dart';
import 'package:userapp/models/route_model.dart';
import 'package:userapp/models/state_model.dart';

class RouteProvider extends ChangeNotifier {
  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  final TextEditingController _maxTravellerController = TextEditingController();
  TextEditingController get maxTravellerController => _maxTravellerController;

  final TextEditingController _estimatedDuration = TextEditingController();
  TextEditingController get estimatedDuration => _estimatedDuration;

  set selectedStartDate(value) {
    _selectedStartDate = value;
    notifyListeners();
  }

  int _estimatedTravelDuration = 0;
  int get estimatedTravelDuration => _estimatedTravelDuration;
  set estimatedTravelDuration(value) {
    _estimatedTravelDuration = value;
    notifyListeners();
  }

  StateModel? _selectedFromRoute;
  StateModel? get selectedFromRoute => _selectedFromRoute;
  set selectedFromRoute(value) {
    _selectedFromRoute = value;
    notifyListeners();
  }

  TimeOfDay? _startTime;
  TimeOfDay? get startTime => _startTime;
  set startTime(value) {
    _startTime = value;
    notifyListeners();
  }

  TimeOfDay? _endTime;
  TimeOfDay? get endTime => _endTime;
  set endTime(value) {
    _endTime = value;
    notifyListeners();
  }

  StateModel? _selectedToRoute;
  StateModel? get selectedToRoute => _selectedToRoute;
  set selectedToRoute(value) {
    _selectedToRoute = value;
    notifyListeners();
  }

  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;
  set selectedEndDate(value) {
    _selectedEndDate = value;
    notifyListeners();
  }

  Future<List<RouteModel>>? _routesFuture;
  Future<List<RouteModel>>? get routesFuture => _routesFuture;
  set routesFuture(value) {
    _routesFuture = value;
    notifyListeners();
  }
}
