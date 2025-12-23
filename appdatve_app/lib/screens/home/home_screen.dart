import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedCompany; // VD: Phương Trang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SmartRideVN - Đặt vé xe Việt Nam"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logic đăng xuất
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Chọn hãng xe
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Chọn hãng xe"),
              items: [
                "Phương Trang",
                "Tuấn Hưng",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => selectedCompany = val),
            ),
            SizedBox(height: 20),
            // 2. Chọn ngày (Style)
            ListTile(
              title: Text("Ngày khởi hành"),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Gọi API search và chuyển sang màn hình danh sách chuyến
              },
              child: Text("TÌM CHUYẾN XE"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    // Logic đăng xuất, ví dụ: xóa token và chuyển về màn hình đăng nhập
    print("Đăng xuất thành công!");
    Navigator.pushReplacementNamed(
      context,
      '/login',
    ); // Điều hướng về màn hình đăng nhập
  }
}
