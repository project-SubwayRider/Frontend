// main.dart
import 'package:deliveryapp/data/options.dart';
import 'package:deliveryapp/screens/request_list_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/delivery_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/my_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/review_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/completed_orders_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/deliverying_base.dart';
import 'screens/deliverying_d.dart';
import 'screens/delivery_detail_base.dart';
import 'screens/delivery_detail_deliverer.dart';
import 'package:deliveryapp/data/order_history_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadLocationsFromCsv();
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => const HomeScreen(),
        '/delivery': (context) => const DeliveryFormScreen(),
        '/requests': (context) => const RequestListScreen(),
        '/chat': (context) => const ChatListScreen(),
        '/my': (context) => const MyScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/review': (context) => const ReviewScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/completed': (context) => const CompletedOrdersScreen(),
        '/history': (context) => const OrderHistoryScreen(),
        '/deliverying_d': (context) => const DeliveryingDScreen(),
        '/deliverying_base': (context) {
          final order =
              ModalRoute.of(context)!.settings.arguments as OrderHistory;
          return DeliveryingScreen(order: order);
        },
        '/delivery_detail_deliverer':
            (context) => const DeliveryDetailDelivererScreen(),
        '/delivery_detail_base': (context) {
          final order =
              ModalRoute.of(context)!.settings.arguments as OrderHistory;
          return DeliveryDetailBase(order: order);
        },
      },
    );
  }
}
