import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../models/trip_model.dart';

class TripProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchTrips(
    String from,
    String to,
    String date, {
    int? companyId,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> queryParams = {
        "from": from,
        "to": to,
        "date": date,
      };

      // Nếu có truyền companyId thì thêm vào query string
      if (companyId != null) {
        queryParams["companyId"] = companyId.toString();
      }

      final response = await _api.send.get(
        "/Trips/search",
        queryParameters: queryParams,
      );

      _trips = (response.data as List)
          .map((item) => Trip.fromJson(item))
          .toList();
    } catch (e) {
      _trips = [];
      debugPrint("Lỗi Search: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
