import 'package:flutter/material.dart';
import '../../models/seat_model.dart';

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Giả lập danh sách ghế tầng dưới (A) và tầng trên (B)
  List<Seat> lowerDeck = List.generate(18, (i) => Seat(name: "A${i + 1}"));
  List<Seat> upperDeck = List.generate(18, (i) => Seat(name: "B${i + 1}"));

  List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chọn chỗ ngồi"),
          backgroundColor: Colors.orange,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tầng dưới (A)"),
              Tab(text: "Tầng trên (B)"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildSeatGrid(lowerDeck), // Tầng 1
                  _buildSeatGrid(upperDeck), // Tầng 2
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng lưới ghế (3 dãy: Trái - Giữa - Phải)
  Widget _buildSeatGrid(List<Seat> seats) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 dãy giường nằm
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: seats.length,
      itemBuilder: (context, index) {
        final seat = seats[index];
        return GestureDetector(
          onTap: seat.isBooked ? null : () => _toggleSeat(seat),
          child: Container(
            decoration: BoxDecoration(
              color: seat.isBooked
                  ? Colors.grey[400]
                  : (seat.isSelected ? Colors.orange : Colors.white),
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.airline_seat_flat,
                    color: seat.isSelected ? Colors.white : Colors.orange,
                  ),
                  Text(
                    seat.name,
                    style: TextStyle(
                      color: seat.isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleSeat(Seat seat) {
    setState(() {
      seat.isSelected = !seat.isSelected;
      if (seat.isSelected) {
        selectedSeats.add(seat.name);
      } else {
        selectedSeats.remove(seat.name);
      }
    });
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Ghế chọn: ${selectedSeats.join(", ")}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: selectedSeats.isEmpty
                ? null
                : () {
                    // Chuyển sang màn hình thanh toán hoặc gọi API /api/Bookings/book
                  },
            child: const Text(
              "TIẾP TỤC",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
