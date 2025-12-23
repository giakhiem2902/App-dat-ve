import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_confirmation_screen.dart'; // Đảm bảo bạn đã tạo file này theo code bên dưới

class SeatSelectionScreen extends StatefulWidget {
  final int tripId;
  final int totalSeats;
  final double price;

  const SeatSelectionScreen({
    super.key,
    required this.tripId,
    required this.totalSeats,
    this.price = 250000,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> selectedSeats = [];

  // Dữ liệu mẫu ghế đã bán (Thực tế sẽ lấy từ API hoặc Provider)
  List<String> bookedSeats = ["A01", "A05", "B02"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn ghế ngồi"),
        backgroundColor: Colors.orange,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "TẦNG DƯỚI"),
            Tab(text: "TẦNG TRÊN"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSeatLegend(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSeatGrid(floor: "A"),
                _buildSeatGrid(floor: "B"),
              ],
            ),
          ),
          _buildBottomBar(currencyFormat),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(Colors.grey[400]!, "Đã bán"),
          _legendItem(Colors.white, "Trống"),
          _legendItem(Colors.orange, "Đang chọn"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSeatGrid({required String floor}) {
    int seatsPerFloor = widget.totalSeats ~/ 2;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 25,
      ),
      itemCount: seatsPerFloor,
      itemBuilder: (context, index) {
        if (index % 3 == 1) return const SizedBox.shrink();

        String seatCode = "$floor${(index + 1).toString().padLeft(2, '0')}";
        bool isBooked = bookedSeats.contains(seatCode);
        bool isSelected = selectedSeats.contains(seatCode);

        return GestureDetector(
          onTap: isBooked
              ? null
              : () {
                  setState(() {
                    isSelected
                        ? selectedSeats.remove(seatCode)
                        : selectedSeats.add(seatCode);
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.grey[400]
                  : (isSelected ? Colors.orange : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.single_bed,
                  color: isBooked || isSelected ? Colors.white : Colors.orange,
                ),
                Text(
                  seatCode,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isBooked || isSelected
                        ? Colors.white
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(NumberFormat fmt) {
    double totalAmount = selectedSeats.length * widget.price;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Ghế: ${selectedSeats.isEmpty ? 'Chưa chọn' : selectedSeats.join(', ')}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Tổng: ${fmt.format(totalAmount)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: selectedSeats.isEmpty
                  ? null
                  : () => _navigateToConfirmation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "TIẾP TỤC",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          tripId: widget.tripId,
          selectedSeats: selectedSeats,
          totalPrice: selectedSeats.length * widget.price,
        ),
      ),
    );
  }
}
