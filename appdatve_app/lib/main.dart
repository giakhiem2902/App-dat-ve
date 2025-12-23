import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/trip_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/search/trip_list_screen.dart';
import 'screens/booking/seat_selection_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/admin_dashboard_screen.dart';
import 'providers/company_provider.dart';
import 'screens/admin/company_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ],
      child: const FutaCloneApp(),
    ),
  );
}

class FutaCloneApp extends StatelessWidget {
  const FutaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartRideVN - Ứng dụng đặt vé xe khách',
      debugShowCheckedModeBanner: false,

      // Cấu hình Theme màu Cam đặc trưng của hãng xe
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF5722),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF5722),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      // Định nghĩa các màn hình trong App
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/home': (context) => HomeScreen(),
        // Các màn hình sau sẽ nhận tham số qua ModalRoute
        '/trip_list': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          final from = args['fromLocation'] as String? ?? '';
          final to = args['toLocation'] as String? ?? '';
          return TripListScreen(fromLocation: from, toLocation: to);
        },
        '/seat_selection': (context) => SeatSelectionScreen(),
        '/company_management': (context) => const CompanyListScreen(),
      },
    );
  }
}
