/// Core Constants
class AppConstants {
  // Hive Box Names
  static const String refuelBoxName = 'refuel_entries';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String monthYearFormat = 'MMM yyyy';

  // Units
  static const String distanceUnit = 'km';
  static const String fuelUnit = 'L';
  static const String mileageUnit = 'km/L';

  // Default Values
  static const int chartDataPointsLimit = 10;
  static const int historyPageSize = 20;

  // Validation
  static const double minOdometer = 0;
  static const double maxOdometer = 999999;
  static const double minFuel = 0.1;
  static const double maxFuel = 200;
}
