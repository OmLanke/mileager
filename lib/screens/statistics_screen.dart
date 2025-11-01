import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/mileage_service.dart';
import '../widgets/brutalist_widgets.dart';
import '../theme/app_colors.dart';

/// Statistics Screen
/// Displays mileage trends and fuel consumption analytics
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MileageService>(
          builder: (context, service, child) {
            final entries = service.entries;
            final chartEntries = service.getChartEntries(limit: 10);
            final monthlyFuel = service.getMonthlyFuelConsumption();

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
                          'STATISTICS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Mileage Analytics',
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
                              Icons.bar_chart,
                              size: 60,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'NO DATA YET',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textSecondary,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add refuel entries\nto see statistics',
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
                      delegate: SliverChildListDelegate([
                        // Key Stats Summary
                        const BrutalistSectionHeader(
                          title: 'Summary',
                          showDivider: false,
                        ),

                        const SizedBox(height: 8),

                        _buildSummaryStats(service),

                        const SizedBox(height: 32),

                        // Mileage Trend Chart
                        const BrutalistSectionHeader(
                          title: 'Mileage Trend',
                          showDivider: false,
                        ),

                        const SizedBox(height: 8),

                        if (chartEntries.length >= 2)
                          BrutalistCard(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: AppColors.surface,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 250,
                                  child: _buildMileageChart(chartEntries),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'LAST 10 REFUELS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textTertiary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          BrutalistCard(
                            padding: const EdgeInsets.all(32),
                            backgroundColor: AppColors.surface,
                            child: Center(
                              child: Text(
                                'Add more entries to see trend',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // Monthly Fuel Consumption
                        const BrutalistSectionHeader(
                          title: 'Monthly Fuel Usage',
                          showDivider: false,
                        ),

                        const SizedBox(height: 8),

                        if (monthlyFuel.isNotEmpty)
                          BrutalistCard(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: AppColors.surface,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 250,
                                  child: _buildMonthlyFuelChart(monthlyFuel),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'FUEL CONSUMPTION BY MONTH',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textTertiary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 80),
                      ]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryStats(MileageService service) {
    final avgMileage = service.getAverageMileage();
    final bestMileage = service.getBestMileage();
    final worstMileage = service.getWorstMileage();
    final overallEfficiency = service.getOverallEfficiency();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BrutalistStatCard(
                value: avgMileage?.toStringAsFixed(1) ?? '--',
                label: 'Average',
                backgroundColor: AppColors.cardSecondary,
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BrutalistStatCard(
                value: overallEfficiency?.toStringAsFixed(1) ?? '--',
                label: 'Overall',
                backgroundColor: AppColors.cardPrimary,
                icon: Icons.eco,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BrutalistStatCard(
                value: bestMileage?.toStringAsFixed(1) ?? '--',
                label: 'Best',
                backgroundColor: AppColors.cardQuaternary,
                icon: Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BrutalistStatCard(
                value: worstMileage?.toStringAsFixed(1) ?? '--',
                label: 'Worst',
                backgroundColor: AppColors.cardTertiary,
                icon: Icons.arrow_downward,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMileageChart(List<dynamic> entries) {
    // Prepare data points
    final spots = <FlSpot>[];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (entry.mileage != null) {
        spots.add(FlSpot(i.toDouble(), entry.mileage!));
      }
    }

    if (spots.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Calculate min and max for better visualization
    final mileageValues = spots.map((s) => s.y).toList();
    final minY = mileageValues.reduce((a, b) => a < b ? a : b);
    final maxY = mileageValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range * 0.2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border.withOpacity(0.2),
              strokeWidth: 2,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < entries.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      (value.toInt() + 1).toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: range > 5 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.border, width: 3),
        ),
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.accent,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.secondary,
                  strokeWidth: 3,
                  strokeColor: AppColors.primary,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.accent.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.primary,
            tooltipBorder: const BorderSide(color: AppColors.border, width: 2),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipRoundedRadius: 0,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  '${barSpot.y.toStringAsFixed(1)} km/L',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyFuelChart(Map<String, double> monthlyFuel) {
    // Get last 6 months of data
    final sortedKeys = monthlyFuel.keys.toList()..sort();
    final displayKeys =
        sortedKeys.length > 6
            ? sortedKeys.sublist(sortedKeys.length - 6)
            : sortedKeys;

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < displayKeys.length; i++) {
      final key = displayKeys[i];
      final value = monthlyFuel[key]!;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              color: AppColors.chartColors[i % AppColors.chartColors.length],
              width: 24,
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: AppColors.border, width: 3),
            ),
          ],
        ),
      );
    }

    final maxY = monthlyFuel.values.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2,
        minY: 0,
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppColors.primary,
            tooltipBorder: const BorderSide(color: AppColors.border, width: 2),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipRoundedRadius: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)} L',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < displayKeys.length) {
                  final key = displayKeys[value.toInt()];
                  final date = DateTime.parse('$key-01');
                  final month = DateFormat('MMM').format(date);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      month,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.border, width: 3),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 100 ? 20 : 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border.withOpacity(0.2),
              strokeWidth: 2,
            );
          },
        ),
        barGroups: barGroups,
      ),
    );
  }
}
