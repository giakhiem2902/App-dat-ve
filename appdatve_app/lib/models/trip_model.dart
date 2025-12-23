class Trip {
  final int id;
  final String companyName;
  final String fromLocation;
  final String toLocation;
  final DateTime startTime;
  final double price;
  final int availableSeats;
  final String busType; // Ví dụ: Limousine, Giường nằm

  Trip({
    required this.id,
    required this.companyName,
    required this.fromLocation,
    required this.toLocation,
    required this.startTime,
    required this.price,
    required this.availableSeats,
    required this.busType,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      companyName: json['companyName'] ?? 'Nhà xe ABC',
      fromLocation: json['fromLocation'],
      toLocation: json['toLocation'],
      startTime: DateTime.parse(json['startTime']),
      price: (json['price'] as num).toDouble(),
      availableSeats: json['availableSeats'] ?? 0,
      busType: json['busType'] ?? 'Ghế ngồi',
    );
  }
}
