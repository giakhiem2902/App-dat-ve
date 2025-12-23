import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/company_provider.dart';
import 'trip_list_screen.dart';

class TripSelectionScreen extends StatefulWidget {
  // Đồng bộ tên tham số với HomeScreen và main.dart
  final int? companyId;
  final String? companyName;

  const TripSelectionScreen({super.key, this.companyId, this.companyName});

  @override
  State<TripSelectionScreen> createState() => _TripSelectionScreenState();
}

class _TripSelectionScreenState extends State<TripSelectionScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int? _selectedCompanyId;

  @override
  void initState() {
    super.initState();
    // Gán ID hãng xe nhận được từ trang Home vào Dropdown
    _selectedCompanyId = widget.companyId;
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName ?? "Thông tin chuyến đi"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Dropdown chọn Hãng xe
            DropdownButtonFormField<int>(
              value: _selectedCompanyId,
              isExpanded: true, // Tránh lỗi tràn văn bản
              decoration: const InputDecoration(
                labelText: "Chọn hãng xe",
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
              items: companyProvider.companies.map((company) {
                return DropdownMenuItem(
                  value: company.id,
                  child: Text(company.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCompanyId = val),
            ),
            const SizedBox(height: 20),

            // 2. Điểm đi
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: "Điểm khởi hành",
                hintText: "Ví dụ: Sài Gòn",
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.swap_vert, color: Colors.orange, size: 30),
            const SizedBox(height: 10),

            // 3. Điểm đến
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: "Điểm đến",
                hintText: "Ví dụ: Đà Lạt",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Chọn ngày đi
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.orange),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ngày khởi hành",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Nút Tìm kiếm
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSearch,
                child: const Text(
                  "TÌM CHUYẾN XE",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _handleSearch() {
    if (_fromController.text.isEmpty ||
        _toController.text.isEmpty ||
        _selectedCompanyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ thông tin"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Chuyển sang trang danh sách chuyến xe bằng Named Route
    Navigator.pushNamed(
      context,
      '/trip_list',
      arguments: {
        'companyId': _selectedCompanyId,
        'fromLocation': _fromController.text.trim(),
        'toLocation': _toController.text.trim(),
        'date': _selectedDate,
      },
    );
  }
}
