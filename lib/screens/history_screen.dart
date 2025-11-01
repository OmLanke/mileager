import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/mileage_service.dart';
import '../widgets/brutalist_widgets.dart';
import '../theme/app_colors.dart';
import '../core/constants.dart';
import 'add_refuel_screen.dart';

/// History Screen
/// Displays all refuel entries in a list with edit/delete options
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MileageService>(
          builder: (context, service, child) {
            final entries = service.entries;

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
                          'HISTORY',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${entries.length} ${entries.length == 1 ? 'Entry' : 'Entries'}',
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

                // Entry List
                if (entries.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.history,
                              size: 60,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'NO HISTORY YET',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textSecondary,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your refuel entries\nwill appear here',
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
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final entry = entries[index];
                        final dateFormat = DateFormat(AppConstants.dateFormat);

                        // Determine card background color based on index
                        final cardColors = [
                          AppColors.surface,
                          AppColors.secondary.withOpacity(0.2),
                          AppColors.cardSecondary.withOpacity(0.2),
                          AppColors.cardTertiary.withOpacity(0.2),
                          AppColors.cardQuaternary.withOpacity(0.2),
                        ];
                        final cardColor = cardColors[index % cardColors.length];

                        return BrutalistCard(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: cardColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddRefuelScreen(entry: entry),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date and Edit Icon
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dateFormat.format(entry.date),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.textSecondary,
                                    size: 24,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Main Stats Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Odometer & Fuel
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Odometer
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.speed,
                                              size: 20,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              NumberFormat(
                                                '#,##0',
                                              ).format(entry.odometer),
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.textPrimary,
                                                height: 1.0,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'km',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12),

                                        // Fuel
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_gas_station,
                                              size: 20,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              entry.fuelLitres.toStringAsFixed(
                                                1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.textPrimary,
                                                height: 1.0,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'L',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Distance (if available)
                                        if (entry.distanceTraveled != null) ...[
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.route,
                                                size: 20,
                                                color: AppColors.textSecondary,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${NumberFormat('#,##0').format(entry.distanceTraveled)} km traveled',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  // Mileage Badge
                                  if (entry.mileage != null)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        border: Border.all(
                                          color: AppColors.border,
                                          width: 3,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            entry.mileage!.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.primary,
                                              height: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'km/L',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),

                              // Notes (if available)
                              if (entry.notes.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.note,
                                        size: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          entry.notes,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }, childCount: entries.length),
                    ),
                  ),

                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }
}
