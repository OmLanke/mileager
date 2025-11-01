import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/refuel_entry.dart';
import '../core/constants.dart';

/// Mileage Service
/// Handles all business logic for refuel entries and mileage calculations
class MileageService extends ChangeNotifier {
  late Box<RefuelEntry> _refuelBox;
  List<RefuelEntry> _entries = [];

  /// Get all refuel entries sorted by date (newest first)
  List<RefuelEntry> get entries => _entries;

  /// Get all entries sorted by date (oldest first) for calculations
  List<RefuelEntry> get entriesChronological {
    final sorted = List<RefuelEntry>.from(_entries);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  /// Initialize the service and load data from Hive
  Future<void> initialize() async {
    _refuelBox = await Hive.openBox<RefuelEntry>(AppConstants.refuelBoxName);
    await _loadEntries();
  }

  /// Load all entries from Hive and recalculate mileage
  Future<void> _loadEntries() async {
    _entries = _refuelBox.values.toList();
    _entries.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    await _recalculateAllMileage();
    notifyListeners();
  }

  /// Add a new refuel entry
  Future<void> addEntry(RefuelEntry entry) async {
    await _refuelBox.put(entry.id, entry);
    await _loadEntries();
  }

  /// Update an existing refuel entry
  Future<void> updateEntry(RefuelEntry entry) async {
    await _refuelBox.put(entry.id, entry);
    await _loadEntries();
  }

  /// Delete a refuel entry
  Future<void> deleteEntry(String id) async {
    await _refuelBox.delete(id);
    await _loadEntries();
  }

  /// Delete all entries (with confirmation)
  Future<void> deleteAllEntries() async {
    await _refuelBox.clear();
    await _loadEntries();
  }

  /// Recalculate mileage for all entries
  /// Mileage = (currentOdometer - previousOdometer) / currentFuelLitres
  Future<void> _recalculateAllMileage() async {
    final sorted = entriesChronological;

    for (int i = 0; i < sorted.length; i++) {
      if (i == 0) {
        // First entry has no previous entry, so no mileage calculation
        sorted[i].mileage = null;
        sorted[i].distanceTraveled = null;
      } else {
        final current = sorted[i];
        final previous = sorted[i - 1];

        // Calculate distance traveled
        final distance = current.odometer - previous.odometer;

        // Calculate mileage (km per litre)
        final mileage = distance / current.fuelLitres;

        current.distanceTraveled = distance;
        current.mileage = mileage;
      }

      // Save updated entry back to Hive
      await sorted[i].save();
    }
  }

  /// Get the latest mileage value
  double? getLatestMileage() {
    if (_entries.isEmpty) return null;

    // Find the most recent entry with a mileage value
    for (var entry in _entries) {
      if (entry.mileage != null) {
        return entry.mileage;
      }
    }

    return null;
  }

  /// Calculate overall average mileage across all entries
  double? getAverageMileage() {
    final entriesWithMileage =
        _entries.where((e) => e.mileage != null && e.mileage! > 0).toList();

    if (entriesWithMileage.isEmpty) return null;

    final sum = entriesWithMileage.fold<double>(
      0,
      (sum, entry) => sum + entry.mileage!,
    );

    return sum / entriesWithMileage.length;
  }

  /// Get total distance traveled
  double getTotalDistance() {
    if (_entries.length < 2) return 0;

    final sorted = entriesChronological;
    final firstOdometer = sorted.first.odometer;
    final lastOdometer = sorted.last.odometer;

    return lastOdometer - firstOdometer;
  }

  /// Get total fuel consumed
  double getTotalFuel() {
    return _entries.fold<double>(0, (sum, entry) => sum + entry.fuelLitres);
  }

  /// Get overall fuel efficiency
  /// Total distance / Total fuel
  double? getOverallEfficiency() {
    final totalDistance = getTotalDistance();
    final totalFuel = getTotalFuel();

    if (totalFuel == 0 || totalDistance == 0) return null;

    return totalDistance / totalFuel;
  }

  /// Get best mileage achieved
  double? getBestMileage() {
    final entriesWithMileage =
        _entries.where((e) => e.mileage != null).toList();

    if (entriesWithMileage.isEmpty) return null;

    return entriesWithMileage
        .map((e) => e.mileage!)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Get worst mileage achieved
  double? getWorstMileage() {
    final entriesWithMileage =
        _entries.where((e) => e.mileage != null).toList();

    if (entriesWithMileage.isEmpty) return null;

    return entriesWithMileage
        .map((e) => e.mileage!)
        .reduce((a, b) => a < b ? a : b);
  }

  /// Get entries for chart display (limited to recent entries)
  List<RefuelEntry> getChartEntries({int limit = 10}) {
    final entriesWithMileage =
        entriesChronological.where((e) => e.mileage != null).toList();

    if (entriesWithMileage.length <= limit) {
      return entriesWithMileage;
    }

    return entriesWithMileage.sublist(entriesWithMileage.length - limit);
  }

  /// Get monthly fuel consumption data
  Map<String, double> getMonthlyFuelConsumption() {
    final Map<String, double> monthlyData = {};

    for (var entry in _entries) {
      final key =
          '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}';
      monthlyData[key] = (monthlyData[key] ?? 0) + entry.fuelLitres;
    }

    return monthlyData;
  }

  /// Get monthly distance traveled
  Map<String, double> getMonthlyDistance() {
    final Map<String, double> monthlyData = {};

    for (var entry in _entries) {
      if (entry.distanceTraveled != null) {
        final key =
            '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}';
        monthlyData[key] = (monthlyData[key] ?? 0) + entry.distanceTraveled!;
      }
    }

    return monthlyData;
  }

  /// Check if an odometer reading is valid (higher than the latest)
  bool isOdometerValid(double odometer, {String? excludeId}) {
    if (_entries.isEmpty) return true;

    final sorted = entriesChronological;
    final latestEntry =
        excludeId != null
            ? sorted.where((e) => e.id != excludeId).lastOrNull
            : sorted.last;

    if (latestEntry == null) return true;

    return odometer > latestEntry.odometer;
  }

  /// Get the latest odometer reading
  double? getLatestOdometer() {
    if (_entries.isEmpty) return null;

    final sorted = entriesChronological;
    return sorted.last.odometer;
  }

  /// Export all data to JSON
  Map<String, dynamic> exportToJson() {
    return {
      'exportDate': DateTime.now().toIso8601String(),
      'entries': _entries.map((e) => e.toJson()).toList(),
    };
  }

  /// Import data from JSON
  Future<void> importFromJson(Map<String, dynamic> json) async {
    final List<dynamic> entriesJson = json['entries'] as List;

    for (var entryJson in entriesJson) {
      final entry = RefuelEntry.fromJson(entryJson as Map<String, dynamic>);
      await _refuelBox.put(entry.id, entry);
    }

    await _loadEntries();
  }
}
