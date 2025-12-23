import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- THÊM MỚI ---
  // Biến lưu trữ quyền của người dùng hiện tại
  List<String> _userRoles = [];
  List<String> get userRoles => _userRoles;
  // ----------------

  // Hàm Đăng ký
  Future<bool> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _api.send.post(
        "/Auth/register",
        data: {
          "fullName": fullName,
          "email": email,
          "phoneNumber": phone,
          "password": password,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Lỗi Register: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm Đăng nhập - ĐÃ CẬP NHẬT
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _api.send.post(
        "/Auth/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        // 1. Lưu JWT Token
        String token = response.data["token"];
        await _storage.write(key: "token", value: token);

        // 2. CẬP NHẬT: Trích xuất Roles từ Backend trả về
        if (response.data["roles"] != null) {
          _userRoles = List<String>.from(response.data["roles"]);
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi Login: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm Đăng xuất - ĐÃ CẬP NHẬT
  Future<void> logout() async {
    await _storage.delete(key: "token");
    _userRoles = []; // Xóa danh sách quyền khi đăng xuất
    notifyListeners();
  }
}
