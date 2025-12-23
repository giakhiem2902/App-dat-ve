import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/company_provider.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách ngay khi vào trang
    Future.microtask(() => context.read<CompanyProvider>().fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách Hãng xe")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.companies.length,
              itemBuilder: (context, index) {
                final company = provider.companies[index];
                return ListTile(
                  leading: const Icon(Icons.business, color: Colors.orange),
                  title: Text(company.name),
                  subtitle: Text(company.phoneNumber),
                  trailing: const Icon(Icons.edit),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Hiện Dialog thêm hãng xe */
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
