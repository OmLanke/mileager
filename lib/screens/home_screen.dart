import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/mileage_service.dart';
import '../widgets/brutalist_widgets.dart';
import '../theme/app_colors.dart';
import '../core/constants.dart';
import 'add_refuel_screen.dart';

/// Home Dashboard Screen
/// Displays latest mileage, lifetime average, and quick stats
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MileageService>(
          builder: (context, service, child) {
            final latestMileage = service.getLatestMileage();
            final averageMileage = service.getAverageMileage();
            final totalDistance = service.getTotalDistance();
            final totalFuel = service.getTotalFuel();
            final bestMileage = service.getBestMileage();
            final entriesCount = service.entries.length;

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.primary,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MILEAGER',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track Your Fuel Efficiency',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Latest Mileage - Hero Card
                        BrutalistCard(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.all(32),
                          shadowOffset: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_gas_station,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text(
                                      'LATEST MILEAGE',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                latestMileage != null
                                    ? latestMileage.toStringAsFixed(2)
                                    : '--',
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  height: 1.0,
                                  letterSpacing: -3.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'KM/L',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Quick Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: BrutalistStatCard(
                                value:
                                    averageMileage != null
                                        ? averageMileage.toStringAsFixed(1)
                                        : '--',
                                label: 'Avg Mileage',
                                backgroundColor: AppColors.cardSecondary,
                                icon: Icons.analytics,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: BrutalistStatCard(
                                value:
                                    bestMileage != null
                                        ? bestMileage.toStringAsFixed(1)
                                        : '--',
                                label: 'Best',
                                backgroundColor: AppColors.cardQuaternary,
                                icon: Icons.star,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: BrutalistStatCard(
                                value:
                                    totalDistance > 0
                                        ? NumberFormat(
                                          '#,##0',
                                        ).format(totalDistance)
                                        : '0',
                                label: 'Total KM',
                                backgroundColor: AppColors.cardTertiary,
                                icon: Icons.route,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: BrutalistStatCard(
                                value:
                                    totalFuel > 0
                                        ? totalFuel.toStringAsFixed(0)
                                        : '0',
                                label: 'Total Fuel (L)',
                                backgroundColor: AppColors.info,
                                icon: Icons.water_drop,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Entries Section
                if (entriesCount > 0) ...[
                  const SliverToBoxAdapter(
                    child: BrutalistSectionHeader(title: 'Recent Entries'),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index >= 3) return null;
                      if (index >= service.entries.length) return null;

                      final entry = service.entries[index];
                      final dateFormat = DateFormat(AppConstants.dateFormat);

                      return BrutalistCard(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.surface,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateFormat.format(entry.date),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.speed,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${NumberFormat('#,##0').format(entry.odometer)} km',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.local_gas_station,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${entry.fuelLitres.toStringAsFixed(1)} L',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (entry.mileage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 3,
                                  ),
                                ),
                                child: Text(
                                  '${entry.mileage!.toStringAsFixed(1)}\nkm/L',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }, childCount: entriesCount > 3 ? 3 : entriesCount),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],

                // Empty State
                if (entriesCount == 0)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 60,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'NO ENTRIES YET',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textSecondary,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap the + button to add\nyour first refuel entry',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),

      // Floating Action Button - Quick Add
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(8, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRefuelScreen()),
            );
          },
          icon: const Icon(Icons.add, size: 28),
          label: const Text(
            'ADD REFUEL',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
