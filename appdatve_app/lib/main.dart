import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/company_provider.dart';

// Import Screens - Hãy đảm bảo đường dẫn khớp với folder bạn đã chia
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/user/trip_selection_screen.dart'; // Màn hình mới
import 'screens/user/trip_list_screen.dart'; // Chuyển từ search sang user
import 'screens/user/seat_selection_screen.dart'; // Chuyển từ booking sang user
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/company_list_screen.dart';
import 'providers/booking_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
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
      title: 'SmartRideVN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF5722),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF5722),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // 1. Nếu đã có Token thì vào Home, chưa có thì vào Login
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/company_management': (context) => const CompanyListScreen(),

        // 2. Route cho trang chọn thông tin chuyến (Lấy từ HomeScreen)
        '/trip_selection': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return TripSelectionScreen(
            companyId: args?['companyId'],
            companyName: args?['companyName'],
          );
        },

        // 3. Route cho danh sách chuyến xe
        '/trip_list': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return TripListScreen(
            companyId: args?['companyId'] ?? 0,
            fromLocation: args?['fromLocation'] ?? '',
            toLocation: args?['toLocation'] ?? '',
            date: args?['date'] ?? DateTime.now(),
          );
        },

        // 4. Route chọn ghế
        '/seat_selection': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return SeatSelectionScreen(
            tripId: args?['tripId'] ?? 0,
            totalSeats: args?['totalSeats'] ?? 40,
          );
        },
      },
    );
  }
}
