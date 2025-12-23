class Company {
  final int? id;
  final String name;
  final String logoUrl;
  final String phoneNumber;

  Company({
    this.id,
    required this.name,
    required this.logoUrl,
    required this.phoneNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
