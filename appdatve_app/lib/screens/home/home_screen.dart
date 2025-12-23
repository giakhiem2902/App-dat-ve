import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/company_provider.dart';
import '../user/booking_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Lấy danh sách hãng xe ngay khi vào trang Home
    Future.microtask(() => context.read<CompanyProvider>().fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartRideVN"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: "Đăng xuất",
          ),
        ],
      ),
      // THÊM DRAWER ĐỂ TRUY CẬP LỊCH SỬ
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, size: 35, color: Colors.orange),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Xin chào Hành khách!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Trang chủ"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Lịch sử đặt vé"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingHistoryScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Về chúng tôi"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: companyProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: () => context.read<CompanyProvider>().fetchCompanies(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chọn hãng xe bạn muốn đi:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: companyProvider.companies.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: companyProvider.companies.length,
                              itemBuilder: (context, index) {
                                final company =
                                    companyProvider.companies[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: company.logoUrl.isNotEmpty
                                          ? Image.network(
                                              company.logoUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) =>
                                                  const Icon(
                                                    Icons.directions_bus,
                                                    size: 40,
                                                  ),
                                            )
                                          : const Icon(
                                              Icons.directions_bus,
                                              size: 40,
                                              color: Colors.orange,
                                            ),
                                    ),
                                    title: Text(
                                      company.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      "Dịch vụ chất lượng cao",
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        // SỬ DỤNG PUSHNAMED ĐỂ ĐỒNG BỘ VỚI MAIN.DART
                                        Navigator.pushNamed(
                                          context,
                                          '/trip_selection',
                                          arguments: {
                                            'companyId': company.id,
                                            'companyName': company.name,
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "ĐẶT VÉ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bus_alert, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text("Hiện chưa có hãng xe nào khả dụng"),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
