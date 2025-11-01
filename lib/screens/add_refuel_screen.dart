import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/mileage_service.dart';
import '../models/refuel_entry.dart';
import '../widgets/brutalist_widgets.dart';
import '../theme/app_colors.dart';
import '../core/constants.dart';

/// Add/Edit Refuel Entry Screen
/// Form for creating new or editing existing refuel entries
class AddRefuelScreen extends StatefulWidget {
  final RefuelEntry? entry;

  const AddRefuelScreen({super.key, this.entry});

  @override
  State<AddRefuelScreen> createState() => _AddRefuelScreenState();
}

class _AddRefuelScreenState extends State<AddRefuelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _fuelController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _odometerController.text = widget.entry!.odometer.toString();
      _fuelController.text = widget.entry!.fuelLitres.toString();
      _notesController.text = widget.entry!.notes;
      _selectedDate = widget.entry!.date;
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _fuelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.surface),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _validateOdometer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter odometer reading';
    }

    final odometer = double.tryParse(value);
    if (odometer == null) {
      return 'Please enter a valid number';
    }

    if (odometer < AppConstants.minOdometer ||
        odometer > AppConstants.maxOdometer) {
      return 'Odometer must be between ${AppConstants.minOdometer} and ${AppConstants.maxOdometer}';
    }

    // Check if odometer is higher than the latest entry (unless editing)
    final service = Provider.of<MileageService>(context, listen: false);
    if (!isEditing || odometer != widget.entry!.odometer) {
      if (!service.isOdometerValid(odometer, excludeId: widget.entry?.id)) {
        final latest = service.getLatestOdometer();
        return 'Odometer must be higher than ${latest?.toStringAsFixed(0) ?? "0"}';
      }
    }

    return null;
  }

  String? _validateFuel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter fuel amount';
    }

    final fuel = double.tryParse(value);
    if (fuel == null) {
      return 'Please enter a valid number';
    }

    if (fuel < AppConstants.minFuel || fuel > AppConstants.maxFuel) {
      return 'Fuel must be between ${AppConstants.minFuel} and ${AppConstants.maxFuel}';
    }

    return null;
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = Provider.of<MileageService>(context, listen: false);

      final entry = RefuelEntry(
        id:
            widget.entry?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        odometer: double.parse(_odometerController.text),
        fuelLitres: double.parse(_fuelController.text),
        date: _selectedDate,
        notes: _notesController.text.trim(),
      );

      if (isEditing) {
        await service.updateEntry(entry);
      } else {
        await service.addEntry(entry);
      }

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Entry updated!' : 'Entry added!',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: AppColors.border, width: 3),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(color: AppColors.border, width: 3),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppConstants.dateFormat);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'EDIT ENTRY' : 'ADD REFUEL'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Instructions Card
            BrutalistCard(
              backgroundColor: AppColors.info.withOpacity(0.3),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 24,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Update your refuel entry details'
                          : 'Enter your current odometer reading and fuel amount',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date Field
            const Text(
              'DATE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            BrutalistTextField(
              controller: TextEditingController(
                text: dateFormat.format(_selectedDate),
              ),
              readOnly: true,
              onTap: _selectDate,
              suffixIcon: const Icon(Icons.calendar_today),
            ),

            const SizedBox(height: 24),

            // Odometer Field
            const Text(
              'ODOMETER READING (KM)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            BrutalistTextField(
              controller: _odometerController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateOdometer,
              hintText: 'e.g., 15000',
            ),

            const SizedBox(height: 24),

            // Fuel Field
            const Text(
              'FUEL ADDED (LITRES)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            BrutalistTextField(
              controller: _fuelController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateFuel,
              hintText: 'e.g., 45.5',
            ),

            const SizedBox(height: 24),

            // Notes Field
            const Text(
              'NOTES (OPTIONAL)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            BrutalistTextField(
              controller: _notesController,
              maxLines: 3,
              hintText: 'e.g., Highway driving, Full tank',
            ),

            const SizedBox(height: 32),

            // Save Button
            BrutalistButton(
              text: isEditing ? 'Update Entry' : 'Add Entry',
              onPressed: _isLoading ? null : _saveEntry,
              backgroundColor: AppColors.secondary,
              textColor: AppColors.primary,
              icon: isEditing ? Icons.check : Icons.add,
              isLarge: true,
            ),

            if (isEditing) ...[
              const SizedBox(height: 16),

              // Delete Button
              BrutalistButton(
                text: 'Delete Entry',
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    side: const BorderSide(
                                      color: AppColors.border,
                                      width: 4,
                                    ),
                                  ),
                                  title: const Text(
                                    'DELETE ENTRY?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  content: const Text(
                                    'This action cannot be undone.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('CANCEL'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                      ),
                                      child: const Text('DELETE'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirmed == true && mounted) {
                            final service = Provider.of<MileageService>(
                              context,
                              listen: false,
                            );
                            await service.deleteEntry(widget.entry!.id);

                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                backgroundColor: AppColors.error,
                textColor: Colors.white,
                icon: Icons.delete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
