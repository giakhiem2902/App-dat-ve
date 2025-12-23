import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../models/company_model.dart';

class CompanyProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Company> _companies = [];
  List<Company> get companies => _companies;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _api.send.get("/Companies");
      _companies = (response.data as List)
          .map((item) => Company.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint("Lỗi tải hãng xe: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
