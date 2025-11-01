import 'package:hive/hive.dart';

part 'refuel_entry.g.dart';

/// Refuel Entry Model
/// Represents a single refueling event with odometer reading and fuel amount
@HiveType(typeId: 0)
class RefuelEntry extends HiveObject {
  /// Unique identifier for this entry
  @HiveField(0)
  final String id;

  /// Odometer reading at time of refuel (in kilometers)
  @HiveField(1)
  final double odometer;

  /// Amount of fuel added (in litres)
  @HiveField(2)
  final double fuelLitres;

  /// Date and time of refuel
  @HiveField(3)
  final DateTime date;

  /// Optional notes about this refuel
  @HiveField(4)
  final String notes;

  /// Calculated mileage for this refuel (km/L)
  /// This is calculated based on the difference from the previous entry
  @HiveField(5)
  double? mileage;

  /// Distance traveled since last refuel (in kilometers)
  @HiveField(6)
  double? distanceTraveled;

  RefuelEntry({
    required this.id,
    required this.odometer,
    required this.fuelLitres,
    required this.date,
    this.notes = '',
    this.mileage,
    this.distanceTraveled,
  });

  /// Create a copy of this entry with updated fields
  RefuelEntry copyWith({
    String? id,
    double? odometer,
    double? fuelLitres,
    DateTime? date,
    String? notes,
    double? mileage,
    double? distanceTraveled,
  }) {
    return RefuelEntry(
      id: id ?? this.id,
      odometer: odometer ?? this.odometer,
      fuelLitres: fuelLitres ?? this.fuelLitres,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      mileage: mileage ?? this.mileage,
      distanceTraveled: distanceTraveled ?? this.distanceTraveled,
    );
  }

  /// Convert to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'odometer': odometer,
      'fuelLitres': fuelLitres,
      'date': date.toIso8601String(),
      'notes': notes,
      'mileage': mileage,
      'distanceTraveled': distanceTraveled,
    };
  }

  /// Create from JSON for import
  factory RefuelEntry.fromJson(Map<String, dynamic> json) {
    return RefuelEntry(
      id: json['id'] as String,
      odometer: (json['odometer'] as num).toDouble(),
      fuelLitres: (json['fuelLitres'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? '',
      mileage:
          json['mileage'] != null ? (json['mileage'] as num).toDouble() : null,
      distanceTraveled:
          json['distanceTraveled'] != null
              ? (json['distanceTraveled'] as num).toDouble()
              : null,
    );
  }

  @override
  String toString() {
    return 'RefuelEntry(id: $id, odometer: $odometer, fuel: $fuelLitres L, '
        'date: $date, mileage: ${mileage?.toStringAsFixed(2) ?? "N/A"} km/L)';
  }
}
