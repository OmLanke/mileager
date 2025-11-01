import '../models/refuel_entry.dart';
import '../services/mileage_service.dart';

/// Sample Data Seeder
/// Generates sample refuel entries for demonstration purposes
class SampleDataSeeder {
  /// Add sample entries to the database
  static Future<void> seedSampleData(MileageService service) async {
    // Only seed if database is empty
    if (service.entries.isNotEmpty) return;

    final now = DateTime.now();

    // Sample entries over the past 3 months
    final sampleEntries = [
      RefuelEntry(
        id: '1',
        odometer: 10000,
        fuelLitres: 45.0,
        date: now.subtract(const Duration(days: 90)),
        notes: 'First entry - Full tank',
      ),
      RefuelEntry(
        id: '2',
        odometer: 10650,
        fuelLitres: 42.5,
        date: now.subtract(const Duration(days: 83)),
        notes: 'Highway driving',
      ),
      RefuelEntry(
        id: '3',
        odometer: 11280,
        fuelLitres: 44.0,
        date: now.subtract(const Duration(days: 76)),
        notes: 'City traffic',
      ),
      RefuelEntry(
        id: '4',
        odometer: 11950,
        fuelLitres: 43.0,
        date: now.subtract(const Duration(days: 69)),
        notes: 'Mixed driving',
      ),
      RefuelEntry(
        id: '5',
        odometer: 12620,
        fuelLitres: 41.5,
        date: now.subtract(const Duration(days: 62)),
        notes: 'Long trip',
      ),
      RefuelEntry(
        id: '6',
        odometer: 13250,
        fuelLitres: 43.5,
        date: now.subtract(const Duration(days: 55)),
        notes: 'Regular commute',
      ),
      RefuelEntry(
        id: '7',
        odometer: 13900,
        fuelLitres: 42.0,
        date: now.subtract(const Duration(days: 48)),
        notes: 'Weekend getaway',
      ),
      RefuelEntry(
        id: '8',
        odometer: 14560,
        fuelLitres: 44.5,
        date: now.subtract(const Duration(days: 41)),
        notes: 'City driving',
      ),
      RefuelEntry(
        id: '9',
        odometer: 15220,
        fuelLitres: 43.0,
        date: now.subtract(const Duration(days: 34)),
        notes: 'Highway trip',
      ),
      RefuelEntry(
        id: '10',
        odometer: 15850,
        fuelLitres: 41.0,
        date: now.subtract(const Duration(days: 27)),
        notes: 'Efficient driving',
      ),
      RefuelEntry(
        id: '11',
        odometer: 16500,
        fuelLitres: 42.8,
        date: now.subtract(const Duration(days: 20)),
        notes: 'Mixed conditions',
      ),
      RefuelEntry(
        id: '12',
        odometer: 17150,
        fuelLitres: 43.2,
        date: now.subtract(const Duration(days: 13)),
        notes: 'Regular driving',
      ),
      RefuelEntry(
        id: '13',
        odometer: 17800,
        fuelLitres: 42.5,
        date: now.subtract(const Duration(days: 6)),
        notes: 'Full tank',
      ),
    ];

    // Add all sample entries
    for (var entry in sampleEntries) {
      await service.addEntry(entry);
    }
  }
}
