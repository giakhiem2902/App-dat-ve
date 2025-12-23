import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../models/trip_model.dart';

class TripProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchTrips(String from, String to, String date) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Giả sử API: /api/Trips/search?from=...&to=...&date=...
      final response = await _api.send.get(
        "/Trips/search",
        queryParameters: {"from": from, "to": to, "date": date},
      );

      _trips = (response.data as List)
          .map((item) => Trip.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint("Lỗi tìm chuyến xe: $e");
      _trips = []; // Xóa danh sách cũ nếu lỗi
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
