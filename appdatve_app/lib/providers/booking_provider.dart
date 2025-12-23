import 'package:flutter/material.dart';
import '../core/network/api_service.dart';

class BookingProvider with ChangeNotifier {
  List<dynamic> _history = [];
  bool _isLoading = false;

  List<dynamic> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> fetchMyHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().send.get('/bookings/my-history');
      if (response.statusCode == 200) {
        _history = response.data;
      }
    } catch (e) {
      print("Lỗi lấy lịch sử: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
