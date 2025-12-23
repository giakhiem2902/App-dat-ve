class Seat {
  final String name; // A1, A2, B1...
  bool isBooked; // Đã có người đặt chưa (lấy từ Backend)
  bool isSelected; // Người dùng đang chọn

  Seat({required this.name, this.isBooked = false, this.isSelected = false});
}
