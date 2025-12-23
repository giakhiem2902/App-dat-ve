import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';
import 'seat_selection_screen.dart';

class TripListScreen extends StatefulWidget {
  final int companyId;
  final String fromLocation;
  final String toLocation;
  final DateTime date;

  const TripListScreen({
    super.key,
    required this.companyId,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
  });

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API tìm kiếm ngay khi trang được khởi tạo
    _fetchTrips();
  }

  // Tách hàm fetch để dễ quản lý và gọi lại nếu cần (ví dụ: kéo để làm mới)
  void _fetchTrips() {
    Future.microtask(
      () => context.read<TripProvider>().searchTrips(
        widget.fromLocation,
        widget.toLocation,
        DateFormat('yyyy-MM-dd').format(widget.date),
        companyId: widget.companyId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Tiêu đề hiển thị lộ trình và ngày đi rõ ràng
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.fromLocation} ➔ ${widget.toLocation}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(widget.date),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            _fetchTrips(), // Cho phép vuốt để tải lại danh sách
        child: tripProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            : tripProvider.trips.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: tripProvider.trips.length,
                itemBuilder: (context, index) {
                  final trip = tripProvider.trips[index];
                  return _buildTripCard(trip, currencyFormat);
                },
              ),
      ),
    );
  }

  Widget _buildTripCard(dynamic trip, NumberFormat fmt) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _navigateToSeatSelection(trip),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    fmt.format(trip.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.directions_bus,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    trip.busType,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${trip.availableSeats} ghế trống",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 1, color: Colors.black12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Giờ khởi hành",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(trip.startTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateToSeatSelection(trip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "CHỌN CHỖ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        // Tránh lỗi tràn khi hiện bàn phím hoặc màn hình nhỏ
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bus_alert_rounded, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Không tìm thấy chuyến xe!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Vui lòng thử chọn ngày khác hoặc đổi lộ trình.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSeatSelection(dynamic trip) {
    if (trip.id == null) {
      print("Lỗi: Trip ID bị null");
      return;
    }
    // Sử dụng pushNamed để đồng bộ với cấu hình trong main.dart
    Navigator.pushNamed(
      context,
      '/seat_selection',
      arguments: {'tripId': trip.id, 'totalSeats': trip.totalSeats ?? 40},
    );
  }
}
