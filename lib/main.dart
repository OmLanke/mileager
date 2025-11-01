import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/refuel_entry.dart';
import 'services/mileage_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/statistics_screen.dart';
import 'core/sample_data_seeder.dart';

/// Main entry point of the Mileager app
/// Initializes Hive database and launches the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(RefuelEntryAdapter());

  runApp(const MileagerApp());
}

/// Root widget of the application
class MileagerApp extends StatelessWidget {
  const MileagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final service = MileageService();
        // Initialize the service and seed sample data
        service.initialize().then((_) {
          // Uncomment the line below to seed sample data on first run
          // SampleDataSeeder.seedSampleData(service);
        });
        return service;
      },
      child: MaterialApp(
        title: 'Mileager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigator(),
      ),
    );
  }
}

/// Main navigation container with bottom navigation bar
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    StatisticsScreen(),
  ];

  final List<NavigationItem> _navItems = const [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.history, label: 'History'),
    NavigationItem(icon: Icons.bar_chart, label: 'Stats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF000000), // AppColors.border
              width: 4,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items:
              _navItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon, size: 28),
                  label: item.label,
                );
              }).toList(),
        ),
      ),
    );
  }
}

/// Navigation item data class
class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({required this.icon, required this.label});
}
